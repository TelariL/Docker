FROM python:3.12-slim AS builder

WORKDIR /app

COPY . .

ENV PYTHONPATH=/app

RUN pip install --upgrade pip
RUN pip install --no-cache-dir .[test]


FROM builder AS test

ENV PYTHONPATH=/app

CMD ["pytest", "tests"]


FROM python:3.12-slim AS production

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.12/site-packages \
                     /usr/local/lib/python3.12/site-packages

COPY --from=builder /usr/local/bin \
                     /usr/local/bin

COPY src ./src
COPY pyproject.toml .

ENV PYTHONPATH=/app

EXPOSE 8122

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8122"]
