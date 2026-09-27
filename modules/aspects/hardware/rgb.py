import json
import os
from pathlib import Path
import subprocess
import sys
from tempfile import NamedTemporaryFile


KEYBOARD = {
    "name": "Glorious GMMK V2 65 ANSI",
    "usb_vid": "320F",
    "usb_pid": "5045",
}

DEVICE_GROUPS = [
    [
        ("Corsair Vengeance RGB DDR5", "direct"),
        ("EVGA GeForce RTX 3060 Ti FTW3 Ultra LHR", "direct"),
        ("ASRock Z790 Pro RS WiFi", "static"),
    ],
    [("GMMK V2 65 ANSI", "static")],
    [("Signify Netherlands B.V. LCL001", "direct")],
]


def usb_ids(device):
    return tuple(
        (device.get(key) or "").lower().removeprefix("0x")
        for key in ("usb_vid", "usb_pid")
    )


def prepare_config(directory):
    path = directory / "OpenRGB.json"
    settings = json.loads(path.read_text()) if path.exists() else {}

    manual = settings.get("QMKVialRGBDevices") or {}
    manual["devices"] = [
        device for device in (manual.get("devices") or [])
        if usb_ids(device) != usb_ids(KEYBOARD)
    ] + [KEYBOARD]
    settings["QMKVialRGBDevices"] = manual

    detectors = settings.get("Detectors") or {}
    detectors["detectors"] = detectors.get("detectors") or {}
    detectors["detectors"][KEYBOARD["name"]] = True
    settings["Detectors"] = detectors

    # Replace atomically; the temporary file has private (0600) permissions.
    with NamedTemporaryFile("w", dir=directory, delete=False) as output:
        temporary = Path(output.name)
        try:
            json.dump(settings, output, indent=2)
            output.write("\n")
            output.flush()
            temporary.replace(path)
        finally:
            temporary.unlink(missing_ok=True)


def main():
    openrgb, color = sys.argv[1:]
    directory = Path(os.environ["STATE_DIRECTORY"])
    prepare_config(directory)

    status = 0
    for devices in DEVICE_GROUPS:
        command = [openrgb, "--noautoconnect", "--config", str(directory)]
        for name, mode in devices:
            command += ["--device", name, "--mode", mode, "--color", color]
        if subprocess.run(command).returncode != 0:
            status = 1
    return status


if __name__ == "__main__":
    sys.exit(main())
