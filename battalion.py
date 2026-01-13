#!/usr/bin/env python3
"""
Battalion Python controller.

This is a Python reimplementation of the top-level Bash orchestration logic:
- parses CLI args
- validates configuration
- prepares the scan directory structure
- exports the environment variables expected by the existing scan scripts
- runs domain scan and user scan in parallel (unless disabled)
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import urllib.request
from pathlib import Path


def _bool_env(value: bool) -> str:
    # Downstream bash scripts use: if $FLAG ; then ...
    return "true" if value else "false"


def _script_dir() -> Path:
    return Path(__file__).resolve().parent


def _ipinfo_host_ip() -> str:
    # Best-effort: match old behavior (curl ipinfo.io | grep ip ...).
    try:
        with urllib.request.urlopen("https://ipinfo.io/json", timeout=5) as resp:
            data = json.loads(resp.read().decode("utf-8", errors="replace"))
        ip = data.get("ip")
        return str(ip) if ip else ""
    except Exception:
        return ""


def _build_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def _build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="battalion",
        add_help=True,
        formatter_class=argparse.RawTextHelpFormatter,
        description="Battalion controller (Python).",
    )

    p.add_argument("--disable-domain", action="store_true", help="Disable the domain scan.")
    p.add_argument("--disable-user", action="store_true", help="Disable the user scan.")

    p.add_argument("--name", required=True, help="Scan name that appears in output.")
    p.add_argument("--out", required=True, help="Output directory for scan (absolute path preferred).")

    p.add_argument("--domain", help="Domain being targeted by scan (example: google.com).")
    p.add_argument("--subdomain-list", dest="subdomain_list", help="File containing subdomains to verify.")
    p.add_argument("--whitelist", dest="whitelist", help="File containing IP whitelist.")

    p.add_argument("--email-domain", dest="email_domain", help="Email domain (default is domain name).")
    p.add_argument(
        "--email-format",
        dest="email_format",
        help=(
            "Set an email format to prevent discovery tasks.\n"
            "Format like {first}.{l} for 'firstname.lastinitial'."
        ),
    )

    p.add_argument("--company", help="Company name as it appears on LinkedIn.")

    p.add_argument("--nmap", action="store_true", help="Add Nmap scanning to domain scan.")
    p.add_argument("--nmap-aggressive", dest="nmap_aggressive", action="store_true", help="Enable aggressive Nmap scanning.")

    p.add_argument("--shodan", dest="shodan_api_key", help="Shodan API key, enables Shodan scan.")
    p.add_argument("--hunter", dest="hunter_api_key", help="Hunter.io API key, enables Hunter in user scan.")

    p.add_argument("--timeout-http", dest="timeout_http", type=int, help="Timeout in seconds for HTTP detection.")
    p.add_argument("--timeout-eyewitness", dest="timeout_eyewitness", type=int, help="Timeout in seconds for EyeWitness.")

    return p


def main(argv: list[str]) -> int:
    if not argv:
        # Preserve legacy behavior: running with no args prints a short usage line and exits 0.
        print(
            "Usage: battalion --name <name> --out <dir> --domain <domain> --company <company> "
            "[optional parameters] [--help]"
        )
        print("Please use --help for more information.")
        return 0

    parser = _build_parser()
    args = parser.parse_args(argv)

    script_dir = _script_dir()

    domain_scan_enabled = not args.disable_domain
    user_scan_enabled = not args.disable_user

    # Validate configuration similar to the old Bash controller.
    configuration_error = False

    if domain_scan_enabled and not args.domain:
        print("[Error] The domain target must be configured for domain scans.", file=sys.stderr)
        configuration_error = True

    if user_scan_enabled and not args.company:
        print("[Error] If the user scan is enabled a company name must be configured.", file=sys.stderr)
        configuration_error = True

    # Default subdomain list path matches the old controller.
    default_subdomain_list = script_dir / "tools" / "dnsrecon" / "subdomains-top1mil-20000.txt"
    subdomain_list = Path(args.subdomain_list) if args.subdomain_list else default_subdomain_list
    if domain_scan_enabled and not subdomain_list:
        print("[Error] A valid subdomain list file must be configured for domain scans.", file=sys.stderr)
        configuration_error = True

    if configuration_error:
        return 1

    scan_directory = Path(args.out)
    domain_directory = scan_directory / "domain"
    whatweb_directory = scan_directory / "whatweb"
    http_directory = scan_directory / "http"
    nmap_directory = scan_directory / "nmap"
    wordpress_directory = scan_directory / "wordpress"
    eyewitness_directory = scan_directory / "eyewitness-report"
    whois_directory = scan_directory / "whois"
    shodan_directory = scan_directory / "shodan"
    user_directory = scan_directory / "user"
    report_directory = scan_directory / "report"

    for p in (
        scan_directory,
        domain_directory,
        whatweb_directory,
        http_directory,
        nmap_directory,
        wordpress_directory,
        eyewitness_directory,
        whois_directory,
        shodan_directory,
        user_directory,
        report_directory,
    ):
        _build_dir(p)

    # Environment variables expected by the existing scripts.
    env = os.environ.copy()

    env["SCRIPT_DIRECTORY"] = str(script_dir)
    env["BATTALION_DNSRECON_HOME"] = env.get("BATTALION_DNSRECON_HOME", str(script_dir / "tools" / "dnsrecon"))
    env["BATTALION_EYEWITNESS_HOME"] = env.get("BATTALION_EYEWITNESS_HOME", str(script_dir / "tools" / "EyeWitness"))
    env["BATTALION_HARVESTER_HOME"] = env.get("BATTALION_HARVESTER_HOME", str(script_dir / "tools" / "theHarvester"))
    env["BATTALION_WHATWEB_HOME"] = env.get("BATTALION_WHATWEB_HOME", str(script_dir / "tools" / "WhatWeb"))
    env["BATTALION_WPSCAN_HOME"] = env.get("BATTALION_WPSCAN_HOME", str(script_dir / "tools" / "wpscan"))
    env["BATTALION_DNSTWIST_HOME"] = env.get("BATTALION_DNSTWIST_HOME", str(script_dir / "tools" / "dnstwist"))

    env["SCAN_NAME"] = args.name
    env["SCAN_DIRECTORY"] = str(scan_directory)

    env["DOMAIN_TARGET"] = args.domain or ""
    env["COMPANY_NAME"] = args.company or ""

    env["DOMAIN_SUBDOMAIN_LIST"] = str(subdomain_list)
    if args.whitelist:
        env["IP_WHITELIST_FILE"] = args.whitelist

    env["DOMAIN_HTTP_SCAN_TIMEOUT"] = str(args.timeout_http if args.timeout_http is not None else 3)
    env["EYEWITNESS_TIMEOUT"] = str(args.timeout_eyewitness if args.timeout_eyewitness is not None else 15)

    # Nmap flags: keep the same semantics as the Bash controller + domain scan script.
    env["NMAP_ENABLED"] = _bool_env(bool(args.nmap))
    env["NMAP_AGGRESSIVE_ENABLED"] = _bool_env(bool(args.nmap_aggressive))

    env["SHODAN_ENABLED"] = _bool_env(bool(args.shodan_api_key))
    env["HUNTER_ENABLED"] = _bool_env(bool(args.hunter_api_key))
    env["SHODAN_API_KEY"] = args.shodan_api_key or ""
    env["HUNTER_API_KEY"] = args.hunter_api_key or ""

    env["EMAIL_DOMAIN"] = args.email_domain or (args.domain or "")
    if args.email_format:
        env["SPECIFIED_EMAIL_FORMAT"] = args.email_format

    env["DOMAIN_DIRECTORY"] = str(domain_directory)
    env["WHATWEB_DIRECTORY"] = str(whatweb_directory)
    env["HTTP_DIRECTORY"] = str(http_directory)
    env["NMAP_DIRECTORY"] = str(nmap_directory)
    env["WORDPRESS_DIRECTORY"] = str(wordpress_directory)
    env["EYEWITNESS_DIRECTORY"] = str(eyewitness_directory)
    env["WHOIS_DIRECTORY"] = str(whois_directory)
    env["SHODAN_DIRECTORY"] = str(shodan_directory)
    env["USER_DIRECTORY"] = str(user_directory)
    env["REPORT_DIRECTORY"] = str(report_directory)

    env["DOMAIN_SCAN_SCRIPTS"] = str(script_dir / "domain-scan" / "scripts")
    env["USER_SCAN_SCRIPTS"] = str(script_dir / "user-scan" / "scripts")

    # User scan output variables (set by the old controller).
    env["LINKEDIN_RESULTS"] = str(user_directory / "linkedin-users.txt")
    env["POSSIBLE_EMAILS"] = str(user_directory / "possible-emails.txt")
    env["COMPROMISED_STYLE"] = str(user_directory / "compromised-style.txt")
    env["PROBABLE_EMAILS"] = str(user_directory / "probable-emails.txt")
    env["COMPROMISED_EMAILS"] = str(user_directory / "compromised-emails.txt")

    host_ip = _ipinfo_host_ip()
    env["HOST_IP_ADDRESS"] = host_ip

    print(">> Battalion <<\n")
    if host_ip:
        print(f"Running scan '{args.name}' from IP address {host_ip}\n")
    else:
        print(f"Running scan '{args.name}'\n")

    procs: list[tuple[str, subprocess.Popen[object]]] = []

    if domain_scan_enabled:
        domain_scan_path = script_dir / "domain-scan" / "domain-scan.sh"
        p = subprocess.Popen([str(domain_scan_path)], env=env, cwd=str(script_dir))
        procs.append(("Domain scan", p))
        print(f"\t+ Domain scan is enabled and is running with PID {p.pid}.")
    else:
        print("\t- Domain scan is disabled.")

    if user_scan_enabled:
        user_scan_path = script_dir / "user-scan" / "user-scan.sh"
        p = subprocess.Popen([str(user_scan_path)], env=env, cwd=str(script_dir))
        procs.append(("User scan", p))
        print(f"\t+ User scan is enabled and is running with PID {p.pid}.")
    else:
        print("\t- User scan is disabled.")

    print("")

    # Wait for scans to complete.
    exit_code = 0
    for name, p in procs:
        rc = p.wait()
        if rc != 0:
            exit_code = rc if exit_code == 0 else exit_code
        print(f"{name} complete.")

    print(f"\nCompleted scan '{args.name}' in directory {scan_directory}")
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
