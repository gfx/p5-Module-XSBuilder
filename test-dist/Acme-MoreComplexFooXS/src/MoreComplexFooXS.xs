#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT /* we want efficiency */
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#define NEED_newSVpvn_flags
#include "ppport.h"

int the_answer_to_life_the_universe_and_everything();

MODULE = Acme::MoreComplexFooXS    PACKAGE = Acme::MoreComplexFooXS

PROTOTYPES: DISABLE

void
hello()
CODE:
{
    ST(0) = newSViv(the_answer_to_life_the_universe_and_everything());
}
