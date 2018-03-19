FROM python:3.5
ENV PYTHONUNBUFFERED 1

# PACOTES ADICIONAIS P/ IMAGEM RC-SLIM
#RUN apt-get update && apt-get install -qq -y build-essential libpq-dev libffi-dev --no-install-recommends

# LIMPAR PACOTES P/ IMAGEM RC-SLIM
#RUN apt-get clean
#RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY codigo /code/
#COPY start.sh /start.sh
#CMD ["/start.sh"]
