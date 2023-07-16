FROM python:3.8
RUN apt-get update && apt-get install -y curl
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip --no-cache-dir -r requirements.txt
RUN curl -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip -o sonar-scanner.zip \
    && unzip sonar-scanner.zip \
    && mv sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner \
    && rm sonar-scanner.zip
ENV PATH="/opt/sonar-scanner/bin:${PATH}"
ENV SONAR_SCANNER_HOME="/opt/sonar-scanner"
COPY . .
RUN sonar-scanner \
    -Dsonar.projectKey=app \
    -Dsonar.sources=. \
    -Dsonar.host.url=your sonarqube url \
    -Dsonar.login=your sonarqube token \
    -Dsonar.language=py
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--reload", "--workers", "1", "--host", "0.0.0.0", "--port", "8000"]

