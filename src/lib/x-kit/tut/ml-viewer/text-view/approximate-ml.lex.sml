package approximate_ml_lex{
   
    package user_declarations {
      
## lexer
#
# COPYRIGHT (c) 1989,1992 by AT&T Bell Laboratories
#
# A scanner for mapping mapping ML code to pretty print form.
#
# TODO: spaces at the beginning of multi-line comments.


package vb = view_buffer;
package kw = ml_keywords;

Lex_Result
  = EOF
  | NL
  | COM List( Lex_Result )
  | STR List( Lex_Result )
  | TOK { space:  Int,
          kind:   vb::Token_Kind,
          text:   String
        }
  ;

comment_nesting_depth
    =
    REF 0;

result_stk
    =
    REF ([]:  List( Lex_Result ));

char_list = REF ([]:  List( String ));

fun make_string ()
    =
    cat (reverse *char_list)
    before
        char_list := [];

col   =  REF 0;
space =  REF 0;

fun tab ()
    =
    {   n = *col;
        skip = 8 - (n & 0x7);
	#
	space := *space + skip;
	col   := n + skip;
    };

fun expand_tab ()
    =
    {   n = *col;
        skip = 8 - (n & 0x7);
	#
	char_list := (string_conversion::pad_left ' ' skip "") ! *char_list;
	col := n + skip;
    };

fun add_string s
    =
    {   char_list := s ! *char_list;
	#
        col := *col + size s;
    };

fun token tok
    =
    {   space := 0;
	#
        col := *col + size tok.text;
	#
        TOK tok;
    };

fun newline ()
    =
    {   space := 0;
        col   := 0;
        NL;
    };

fun push_line kind
    =
    {   tok = TOK { space => *space, kind, text => make_string() };

	space := 0;
	newline();
        result_stk :=  NL ! tok ! *result_stk;
    };

fun dump_stk kind
    =
    {   tok = TOK { space => *space, kind, text => make_string() };

	space := 0;

	reverse (tok ! *result_stk)
        before
            result_stk := [];
    };

fun mk_id    s =  token (kw::make_token { space => *space, text => s });

fun mk_sym   s =  token ({ space => *space, kind => vb::SYMBOL, text => s });
fun mk_tyvar s =  token ({ space => *space, kind => vb::IDENT,  text => s });
fun mk_con   s =  token ({ space => *space, kind => vb::SYMBOL, text => s });

fun eof ()
    =
    {   char_list  := [];
        result_stk := [];
	#
        space := 0;
        col   := 0;
	#
        comment_nesting_depth := 0;
	#
        EOF;
    };

fun error s
    =
    raise exception FAIL s;

}; #  end of user routines 
exception LEX_ERROR; # Raised if illegal leaf action tried.
package internal {
	 

Yyfinstate = NN Int;
Statedata = { fin:  List( Yyfinstate ), trans: String };
#  transition & final state table 
tab = {
    s = [ 
 (0,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (1,  
"\010\010\010\010\010\010\010\010\010\053\052\010\010\010\010\010\
\\010\010\010\010\010\010\010\010\010\010\010\010\010\010\010\010\
\\051\026\050\026\026\026\026\048\046\045\043\026\042\026\039\026\
\\036\034\034\034\034\034\034\034\034\034\026\033\026\026\026\026\
\\026\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\032\026\031\026\030\
\\026\028\028\028\028\028\028\028\028\028\028\028\028\028\028\028\
\\028\028\028\028\028\028\028\028\028\028\028\027\026\025\011\010\
\\009"
),
 (3,  
"\054\054\054\054\054\054\054\054\054\060\059\054\054\054\054\054\
\\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\
\\054\054\054\054\054\054\054\054\057\054\055\054\054\054\054\054\
\\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\
\\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\
\\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\
\\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\
\\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\054\
\\054"
),
 (5,  
"\061\061\061\061\061\061\061\061\061\067\066\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\065\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\062\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061"
),
 (7,  
"\068\068\068\068\068\068\068\068\068\072\071\068\068\068\068\068\
\\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\
\\070\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\
\\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\
\\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\
\\068\068\068\068\068\068\068\068\068\068\068\068\069\068\068\068\
\\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\
\\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\068\
\\068"
),
 (11,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\012\000\012\012\012\012\000\000\000\012\012\000\012\000\012\
\\022\013\013\013\013\013\013\013\013\013\012\000\012\012\012\012\
\\012\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\012\000\012\000\
\\012\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\012\000\012\000\
\\000"
),
 (12,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\012\000\012\012\012\012\000\000\000\012\012\000\012\000\012\
\\000\000\000\000\000\000\000\000\000\000\012\000\012\012\012\012\
\\012\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\012\000\012\000\
\\012\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\012\000\012\000\
\\000"
),
 (13,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\017\000\
\\013\013\013\013\013\013\013\013\013\013\000\000\000\000\000\000\
\\000\000\000\000\000\014\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (14,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\016\016\016\016\016\016\016\016\016\016\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\015\000\
\\000"
),
 (15,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\016\016\016\016\016\016\016\016\016\016\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (17,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\018\018\018\018\018\018\018\018\018\018\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (18,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\018\018\018\018\018\018\018\018\018\018\000\000\000\000\000\000\
\\000\000\000\000\000\019\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (19,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\021\021\021\021\021\021\021\021\021\021\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\020\000\
\\000"
),
 (20,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\021\021\021\021\021\021\021\021\021\021\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (22,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\017\000\
\\013\013\013\013\013\013\013\013\013\013\000\000\000\000\000\000\
\\000\000\000\000\000\014\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\023\000\000\000\000\000\000\000\
\\000"
),
 (23,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\024\024\024\024\024\024\024\024\024\024\000\000\000\000\000\000\
\\000\024\024\024\024\024\024\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\024\024\024\024\024\024\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (28,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\029\000\000\000\000\000\000\000\000\
\\029\029\029\029\029\029\029\029\029\029\000\000\000\000\000\000\
\\000\029\029\029\029\029\029\029\029\029\029\029\029\029\029\029\
\\029\029\029\029\029\029\029\029\029\029\029\000\000\000\000\029\
\\000\029\029\029\029\029\029\029\029\029\029\029\029\029\029\029\
\\029\029\029\029\029\029\029\029\029\029\029\000\000\000\000\000\
\\000"
),
 (34,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\017\000\
\\035\035\035\035\035\035\035\035\035\035\000\000\000\000\000\000\
\\000\000\000\000\000\014\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (36,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\017\000\
\\035\035\035\035\035\035\035\035\035\035\000\000\000\000\000\000\
\\000\000\000\000\000\014\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\037\000\000\000\000\000\000\000\
\\000"
),
 (37,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\038\038\038\038\038\038\038\038\038\038\000\000\000\000\000\000\
\\000\038\038\038\038\038\038\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\038\038\038\038\038\038\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (39,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\040\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (40,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\041\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (43,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\012\000\012\012\012\012\000\000\044\012\012\000\012\000\012\
\\000\000\000\000\000\000\000\000\000\000\012\000\012\012\012\012\
\\012\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\012\000\012\000\
\\012\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\012\000\012\000\
\\000"
),
 (46,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\047\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (48,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\049\000\000\000\000\000\000\000\000\
\\049\049\049\049\049\049\049\049\049\049\000\000\000\000\000\000\
\\000\049\049\049\049\049\049\049\049\049\049\049\049\049\049\049\
\\049\049\049\049\049\049\049\049\049\049\049\000\000\000\000\049\
\\000\049\049\049\049\049\049\049\049\049\049\049\049\049\049\049\
\\049\049\049\049\049\049\049\049\049\049\049\000\000\000\000\000\
\\000"
),
 (55,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\056\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (57,  
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\058\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
 (61,  
"\061\061\061\061\061\061\061\061\061\000\000\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\000\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\000\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\061\
\\061"
),
 (62,  
"\000\000\000\000\000\000\000\000\000\000\064\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\063\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\\000"
),
    (0, "")];
    fun f x = x;
    s = map f (reverse (tail (reverse s)));
    exception LEX_HACKING_ERROR;
    fun get ((j, x) ! r, i: Int)
            =>
            if (i == j)  x;   else get (r, i); fi;

        get ([], i)
            =>
            raise exception LEX_HACKING_ERROR;
    end;
fun g {   fin => x,   trans => i   }
    =
    {   fin => x,   trans => get (s, i)   };
 vector::from_list (map g 
[{ fin => [], trans => 0},
{ fin => [], trans => 1},
{ fin => [], trans => 1},
{ fin => [], trans => 3},
{ fin => [], trans => 3},
{ fin => [(NN 117)], trans => 5},
{ fin => [(NN 117)], trans => 5},
{ fin => [], trans => 7},
{ fin => [], trans => 7},
{ fin => [(NN 125), (NN 127)], trans => 0},
{ fin => [(NN 127)], trans => 0},
{ fin => [(NN 43), (NN 127)], trans => 11},
{ fin => [(NN 43)], trans => 12},
{ fin => [(NN 70)], trans => 13},
{ fin => [], trans => 14},
{ fin => [], trans => 15},
{ fin => [(NN 63)], trans => 15},
{ fin => [], trans => 17},
{ fin => [(NN 63)], trans => 18},
{ fin => [], trans => 19},
{ fin => [], trans => 20},
{ fin => [(NN 63)], trans => 20},
{ fin => [(NN 70)], trans => 22},
{ fin => [], trans => 23},
{ fin => [(NN 81)], trans => 23},
{ fin => [(NN 13), (NN 127)], trans => 0},
{ fin => [(NN 43), (NN 127)], trans => 12},
{ fin => [(NN 11), (NN 127)], trans => 0},
{ fin => [(NN 43), (NN 127)], trans => 28},
{ fin => [(NN 43)], trans => 28},
{ fin => [(NN 7), (NN 127)], trans => 0},
{ fin => [(NN 17), (NN 127)], trans => 0},
{ fin => [(NN 15), (NN 127)], trans => 0},
{ fin => [(NN 19), (NN 127)], trans => 0},
{ fin => [(NN 66), (NN 127)], trans => 34},
{ fin => [(NN 66)], trans => 34},
{ fin => [(NN 66), (NN 127)], trans => 36},
{ fin => [], trans => 37},
{ fin => [(NN 75)], trans => 37},
{ fin => [(NN 25), (NN 127)], trans => 39},
{ fin => [], trans => 40},
{ fin => [(NN 29)], trans => 0},
{ fin => [(NN 9), (NN 127)], trans => 0},
{ fin => [(NN 43), (NN 127)], trans => 43},
{ fin => [(NN 87)], trans => 0},
{ fin => [(NN 23), (NN 127)], trans => 0},
{ fin => [(NN 21), (NN 127)], trans => 46},
{ fin => [(NN 84)], trans => 0},
{ fin => [(NN 32), (NN 127)], trans => 48},
{ fin => [(NN 32)], trans => 48},
{ fin => [(NN 101), (NN 127)], trans => 0},
{ fin => [(NN 3), (NN 127)], trans => 0},
{ fin => [(NN 5)], trans => 0},
{ fin => [(NN 1), (NN 127)], trans => 0},
{ fin => [(NN 99)], trans => 0},
{ fin => [(NN 99)], trans => 55},
{ fin => [(NN 95)], trans => 0},
{ fin => [(NN 99)], trans => 57},
{ fin => [(NN 90)], trans => 0},
{ fin => [(NN 92)], trans => 0},
{ fin => [(NN 97), (NN 99)], trans => 0},
{ fin => [(NN 117)], trans => 61},
{ fin => [(NN 115)], trans => 62},
{ fin => [(NN 113)], trans => 0},
{ fin => [(NN 108)], trans => 0},
{ fin => [(NN 103)], trans => 0},
{ fin => [(NN 105)], trans => 0},
{ fin => [(NN 110)], trans => 0},
{ fin => [(NN 123)], trans => 0},
{ fin => [(NN 121), (NN 123)], trans => 0},
{ fin => [(NN 3), (NN 123)], trans => 0},
{ fin => [(NN 119)], trans => 0},
{ fin => [(NN 1), (NN 123)], trans => 0}]);
};
package start_states {
	 
	 Yystartstate = STARTSTATE Int;

#  start state definitions 

my ccc = STARTSTATE 3;
my fff = STARTSTATE 7;
my initial = STARTSTATE 1;
my sss = STARTSTATE 5;

 };
Result = user_declarations::Lex_Result;
	 exception LEXER_ERROR; # Raised if illegal leaf action tried */
};

fun make_lexer yyinput =
{	 my yygone0=1;
	 yyb = REF "\n"; 		#  Buffer 
	 yybl = REF 1;		# Buffer length 
	 yybufpos = REF 1;		#  location of next character to use 
	 yygone = REF yygone0;	#  position in file of beginning of buffer 
	 yydone = REF FALSE;		#  eof found yet? 
	 yybegin_i = REF 1;		# Current 'start state' for lexer 

	 yybegin = fn (internal::start_states::STARTSTATE x) =
		 yybegin_i := x;

fun lex () : internal::Result =
{ fun continue () = lex(); 
  { fun scan (s, accepting_leaves:  List( List( internal::Yyfinstate ) ), l, i0) =
	 { fun action (i, NIL) => raise exception LEX_ERROR;
	 action (i, NIL ! l)     => action (i - 1, l);
	 action (i, (node ! acts) ! l) => 
		 case node
		 
		    internal::NN yyk => 
			 ( { fun yymktext () = substring(*yyb, i0, i-i0);
			     yypos = i0 + *yygone;
			 include user_declarations;
			 include internal::start_states;
  {   yybufpos := i;
      case yyk
 

			#  Application actions 

  1 => { tab(); continue(); };
  101 => {   yytext=yymktext();
yybegin sss; add_string yytext; continue(); };
  103 => {   yytext=yymktext();
yybegin initial; add_string yytext; STR(dump_stk vb::SYMBOL); };
  105 => { error "unexpected newline in unclosed string"; };
  108 => { yybegin fff; push_line vb::SYMBOL; continue(); };
  11 => {   yytext=yymktext();
mk_sym yytext; };
  110 => { expand_tab(); continue(); };
  113 => {   yytext=yymktext();
add_string yytext; continue(); };
  115 => {   yytext=yymktext();
add_string yytext; continue(); };
  117 => {   yytext=yymktext();
add_string yytext; continue(); };
  119 => { result_stk := (newline ()) ! *result_stk; continue(); };
  121 => {   yytext=yymktext();
yybegin sss; add_string yytext; continue(); };
  123 => { error "unclosed string"; };
  125 => { error "non-Ascii character"; };
  127 => { error "illegal character"; };
  13 => {   yytext=yymktext();
mk_sym yytext; };
  15 => {   yytext=yymktext();
mk_sym yytext; };
  17 => {   yytext=yymktext();
mk_sym yytext; };
  19 => {   yytext=yymktext();
mk_sym yytext; };
  21 => {   yytext=yymktext();
mk_sym yytext; };
  23 => {   yytext=yymktext();
mk_sym yytext; };
  25 => {   yytext=yymktext();
mk_sym yytext; };
  29 => {   yytext=yymktext();
mk_sym yytext; };
  3 => { space := *space + 1; col := *col + 1; continue(); };
  32 => {   yytext=yymktext();
mk_tyvar yytext; };
  43 => {   yytext=yymktext();
mk_id yytext; };
  5 => { newline(); };
  63 => {   yytext=yymktext();
mk_con yytext; };
  66 => {   yytext=yymktext();
mk_con yytext; };
  7 => {   yytext=yymktext();
mk_sym yytext; };
  70 => {   yytext=yymktext();
mk_con yytext; };
  75 => {   yytext=yymktext();
mk_con yytext; };
  81 => {   yytext=yymktext();
mk_con yytext; };
  84 => {   yytext=yymktext();
yybegin ccc; add_string yytext; comment_nesting_depth := 1; continue(); };
  87 => { error "unmatched close comment"; };
  9 => {   yytext=yymktext();
mk_sym yytext; };
  90 => {   yytext=yymktext();
add_string yytext; comment_nesting_depth := *comment_nesting_depth + 1; continue(); };
  92 => { push_line vb::COMMENT; continue(); };
  95 => {   yytext=yymktext();
add_string yytext;
		    comment_nesting_depth := *comment_nesting_depth - 1;
		    if (*comment_nesting_depth == 0)
		        yybegin initial;
                        COM (dump_stk vb::COMMENT);
		    else
                        continue();
                    fi
                   ; };
  97 => { expand_tab(); continue(); };
  99 => {   yytext=yymktext();
add_string yytext; continue(); };
  _ => raise exception internal::LEXER_ERROR;

		 esac; }; } ); esac; end;    # fun action

	 my { fin, trans } = unsafe::vector::get (internal::tab, s);
	 new_accepting_leaves = fin ! accepting_leaves;
	 if (l == *yybl)
	     if (trans == .trans (vector::get (internal::tab, 0)))
	       action (l, new_accepting_leaves);
	 else	     newchars= if *yydone ""; else yyinput 1024; fi;
	     if ((size newchars) == 0)
		        yydone := TRUE;
		        if (l == i0)  user_declarations::eof ();
		                  else action (l, new_accepting_leaves); fi;
		  else if (l == i0)  yyb := newchars;
			     else yyb := substring(*yyb, i0, l-i0) + newchars; fi;
		       yygone := *yygone+i0;
		       yybl := size *yyb;
		       scan (s, accepting_leaves, l-i0, 0);
	     fi;   # (size newchars) == 0
	     fi;   # trans == $trans ...
	  else new_char = char::to_int (unsafe::char_vector::get(*yyb, l));
		 new_char = if (new_char < 128) new_char; else 128; fi;
		 new_state = char::to_int (unsafe::char_vector::get (trans, new_char));
		 if (new_state == 0) action (l, new_accepting_leaves);
		 else scan (new_state, new_accepting_leaves, l+1, i0); fi;
	 fi;
  };    # fun scan
/*
	 start= if (substring(*yyb,*yybufpos - 1, 1)=="\n") *yybegin_i+1; else *yybegin_i; fi;
*/
	 scan(*yybegin_i /* start */ , NIL, *yybufpos, *yybufpos);   # fun continue
    };   # fun continue
 };    # fun lex
  lex; 
  };   # fun make_lexer
};
