REBAR3_URL=https://s3.amazonaws.com/rebar3/rebar3

ifeq ($(wildcard rebar3),rebar3)
	REBAR3 = $(CURDIR)/rebar3
endif

REBAR3 ?= $(shell test -e `which rebar3` 2>/dev/null && which rebar3 || echo "./rebar3")

ifeq ($(REBAR3),)
	REBAR3 = $(CURDIR)/rebar3
endif

.PHONY: all build clean dialyzer xref doc test publish

all: build

build: $(REBAR3)
	@$(REBAR3) compile

$(REBAR3):
	wget $(REBAR3_URL) || curl -Lo rebar3 $(REBAR3_URL)
	@chmod a+x rebar3

clean:
	@$(REBAR3) clean

dialyzer:
	@$(REBAR3) dialyzer

xref:
	@$(REBAR3) xref

doc: build
	./scripts/hackish_make_docs.sh

test:
	@ERL_AFLAGS="-config test/erlchronos_tests.app.config" $(REBAR3) eunit

publish:
	@$(REBAR3) as publish hex publish
