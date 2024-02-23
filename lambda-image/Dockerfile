FROM public.ecr.aws/lambda/provided:al2023

# Copy requirements.txt
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Update image
RUN dnf install -y g++ python3.11 python3.11-pip python3.11-devel

# Install the specified packages
RUN python3.11 -m pip install -r requirements.txt

# Copy function code
COPY precompile.py ${LAMBDA_TASK_ROOT}
COPY lambda_function.py ${LAMBDA_TASK_ROOT}

RUN python3.11 precompile.py

# Set runtime interface client as default command for the container runtime
ENTRYPOINT [ "python3.11", "-m", "awslambdaric" ]
# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "lambda_function.handler" ]
