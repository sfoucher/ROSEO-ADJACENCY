# Readme

This folder implements a Docker container for the excution of T-MART (with Python 3.11):

Pull the image from Docker Hub:

```docker pull sfoucherq/tmart:latest```

Image building:

```docker build -t tmart:latest -f ./T-MART.dockerfile .```

Run :

```docker run --rm -it --network=host tmart:latest python test_tmart.py```

Interactive run:

```docker run --rm -it --network=host tmart:latest bash```

Share a local folder:

```docker run --rm -it --network=host -v <YOUR_DIR>:/data mart:latest bash```