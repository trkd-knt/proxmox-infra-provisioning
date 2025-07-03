import yaml
import subprocess
import multiprocessing
import argparse
from pathlib import Path

def load_config(path):
    with open(path, 'r') as file:
        return yaml.safe_load(file)

def create_ssh_tunnel(name, config):
    ip = config['ip']
    port = config['port']
    rsa_key = config['rsa_key']
    local_port = config['local_port']
    remote_host = config['remote_host']
    remote_port = config['remote_port']
    user = config['user']

    ssh_command = [
        "ssh",
        "-i", rsa_key,
        "-N",
        "-o", "ServerAliveInterval=60",
        "-o", "ServerAliveCountMax=3",
        "-L", f"{local_port}:{remote_host}:{remote_port}",
        "-p", str(port),
        f"{user}@{ip}"
    ]

    print(f"[{name}] Starting SSH tunnel: {' '.join(ssh_command)}")
    subprocess.run(ssh_command)

def main():
    script_dir = Path(__file__).resolve().parent
    default_config = script_dir / "config.yaml"

    parser = argparse.ArgumentParser(description="SSH Port Forwarder")
    parser.add_argument(
        "-c", "--config",
        default=str(default_config),
        help="Path to config.yaml (default: config.yaml)"
    )
    args = parser.parse_args()

    configs = load_config(args.config)
    processes = []

    for name, conf in configs.items():
        p = multiprocessing.Process(target=create_ssh_tunnel, args=(name, conf))
        p.start()
        processes.append(p)

    try:
        for p in processes:
            p.join()
    except KeyboardInterrupt:
        print("\nStopping tunnels...")
        for p in processes:
            p.terminate()

if __name__ == "__main__":
    main()
