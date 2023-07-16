# Install project dependencies
RUN pip install --upgrade pip --no-cache-dir -r requirements.txt

# Install SonarQube scanner
RUN curl -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip -o sonar-scanner.zip \
    && unzip sonar-scanner.zip \
    && mv sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner \
    && rm sonar-scanner.zip

# Set environment variables for SonarQube
ENV PATH="/opt/sonar-scanner/bin:${PATH}"
ENV SONAR_SCANNER_HOME="/opt/sonar-scanner"

# Copy the FastAPI application code
COPY . .

# Run SonarQube scanner to analyze the code
RUN sonar-scanner \
    -Dsonar.projectKey=app \
    -Dsonar.sources=. \
    -Dsonar.host.url=http://a38e7b04c86e6434cb6f682abf1ebb8b-589094959.ap-south-1.elb.amazonaws.com \
    -Dsonar.login=ecce3e8709daeb0e1cdab7c10ce924cc5c33eb7b \
    -Dsonar.language=py

# Expose the FastAPI application port
EXPOSE 8000

# Start the FastAPI applicatio
CMD ["uvicorn", "app.main:app", "--reload", "--workers", "1", "--host", "0.0.0.0", "--port", "8000"]
