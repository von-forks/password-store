

T = $(wildcard t[0-9][0-9][0-9][0-9]-*.sh)

all: $(T)

$(T):
	@./$@ $(CGIT_TEST_OPTS)

clean:
	$(RM) -rf test-results/
	$(RM) -rf trash\ directory.*/

.PHONY: $(T) clean
