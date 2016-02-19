.PHONY: all policy-agent policy-tool docker-image clean

SRCDIR=.

default: all
all: policy-agent policy-tool 
policy-agent: dist/policy_agent
policy-tool: dist/policy

dist/policy_agent: 
	# Build the kubernetes policy agent
	docker run --rm \
	-v `pwd`:/code \
	calico/build \
	pyinstaller policy_agent.py -ayF 

dist/policy: 
	# Build NetworkPolicy install tool. 
	docker run --rm \
	-v `pwd`:/code \
	calico/build \
	pyinstaller policy.py -ayF 

docker-image: binary
	docker build -t caseydavenport/k8s-policy-agent . 

clean:
	find . -name '*.pyc' -exec rm -f {} +
	-rm -rf dist
	-docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes
