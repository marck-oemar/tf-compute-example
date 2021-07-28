FROM python:3.7

ENV TERRAFORM_VERSION 1.0.2

RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip


COPY ./src /api

WORKDIR /api

RUN pip install --no-cache-dir -r ./requirements.txt

CMD [ "python", "./api.py" ]
#CMD python ./api.py
