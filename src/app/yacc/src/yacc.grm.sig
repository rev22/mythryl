api Mlyacc_Tokens {
    Token (X,Y);
    Semantic_Value;
    bogus_value: (X, X) -> Token (Semantic_Value,X);
    unknown: ((String), X, X) -> Token (Semantic_Value,X);
    value: (X, X) -> Token (Semantic_Value,X);
    verbose: (X, X) -> Token (Semantic_Value,X);
    tyvar: ((String), X, X) -> Token (Semantic_Value,X);
    term: (X, X) -> Token (Semantic_Value,X);
    start: (X, X) -> Token (Semantic_Value,X);
    subst: (X, X) -> Token (Semantic_Value,X);
    rparen: (X, X) -> Token (Semantic_Value,X);
    rbrace: (X, X) -> Token (Semantic_Value,X);
    prog: ((String), X, X) -> Token (Semantic_Value,X);
    prefer: (X, X) -> Token (Semantic_Value,X);
    prec_tag: (X, X) -> Token (Semantic_Value,X);
    prec: ((header::Precedence), X, X) -> Token (Semantic_Value,X);
    percent_token_sig_info: (X, X) -> Token (Semantic_Value,X);
    percent_arg: (X, X) -> Token (Semantic_Value,X);
    percent_pos: (X, X) -> Token (Semantic_Value,X);
    percent_pure: (X, X) -> Token (Semantic_Value,X);
    percent_eop: (X, X) -> Token (Semantic_Value,X);
    of_t: (X, X) -> Token (Semantic_Value,X);
    noshift: (X, X) -> Token (Semantic_Value,X);
    nonterm: (X, X) -> Token (Semantic_Value,X);
    nodefault: (X, X) -> Token (Semantic_Value,X);
    name: (X, X) -> Token (Semantic_Value,X);
    lparen: (X, X) -> Token (Semantic_Value,X);
    lbrace: (X, X) -> Token (Semantic_Value,X);
    keyword: (X, X) -> Token (Semantic_Value,X);
    int: ((String), X, X) -> Token (Semantic_Value,X);
    percent_header: (X, X) -> Token (Semantic_Value,X);
    iddot: ((String), X, X) -> Token (Semantic_Value,X);
    id: (((String, Int)), X, X) -> Token (Semantic_Value,X);
    header: ((String), X, X) -> Token (Semantic_Value,X);
    for_t: (X, X) -> Token (Semantic_Value,X);
    eof_t: (X, X) -> Token (Semantic_Value,X);
    delimiter: (X, X) -> Token (Semantic_Value,X);
    comma: (X, X) -> Token (Semantic_Value,X);
    colon: (X, X) -> Token (Semantic_Value,X);
    change: (X, X) -> Token (Semantic_Value,X);
    bar: (X, X) -> Token (Semantic_Value,X);
    block: (X, X) -> Token (Semantic_Value,X);
    asterisk: (X, X) -> Token (Semantic_Value,X);
    arrow: (X, X) -> Token (Semantic_Value,X);
};
api Mlyacc_Lrvals{
    package tokens:  Mlyacc_Tokens;
    package parser_data: Parser_Data;
    sharing parser_data::token::Token == tokens::Token;
    sharing parser_data::Semantic_Value == tokens::Semantic_Value;
};
