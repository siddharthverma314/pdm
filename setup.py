import setuptools

if __name__ == "__main__":
    setuptools.setup(
        packages=setuptools.find_packages(exclude=["tests/*"]),
        entry_points = {
            "console_scripts": [
                "pdm = pdm.core:main",
            ],
        },
        include_package_data=True,
    )
