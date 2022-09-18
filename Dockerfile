FROM cdrx/pyinstaller-linux:python2

WORKDIR /src

COPY . .

CMD [ "pyinstaller", "-F", "add2vals.py"] 