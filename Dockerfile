FROM python:3.9

WORKDIR /opt/app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8080 8081

CMD ./run.sh
