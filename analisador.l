%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* nome;
    int valor;
} EntradaTabela;

EntradaTabela tabelaSimbolos[100];

int proximoIndice = 0; 
int erro = 0;

%}

%{
enum { 
        IF = 1, 
        ELSE, 
        INT,
        RETURN,
        VOID,
        WHILE,
        MENOR,
        MAIOR,
        IGUAL,
        MENORIGUAL,
        MAIORIGUAL,
        DIFERENTE,
	INCREMENTO,
	DECREMENTO,
	SOMA,
	SUBTRACAO,
	DIVISAO,
	MULTIPLICACAO,
	ATRIBUICAO,
	PONTOVIRGULA,
	VIRGULA,
	ABREPARENTESE,
	FECHAPARENTESE,
	ABRECOLCHETE,
	FECHACOLCHETE,
	ABRECHAVE,
	FECHACHAVE,	
        ERROR,

     };
%}

%x comentario
%option yylineno

%%

[ \t\n] ; // Ignorar espaços em branco e quebras de linha

"if"    { return IF; }
"else"  { return ELSE; }
"int"   {return INT;}
"return" {return RETURN;}
"void" { return VOID;}
"while" {return WHILE;}
"<"  { return MENOR; }
">"  { return MAIOR; }
"=="  { return IGUAL; }
"<="  { return MENORIGUAL; }
">="  { return MAIORIGUAL; }
"!="  { return DIFERENTE; }
"++" {return INCREMENTO;}
"+" {return SOMA;}
"--" {return DECREMENTO;}
"-" {return SUBTRACAO;}
"/" {return DIVISAO;}
"*" {return MULTIPLICACAO;}
"=" {return ATRIBUICAO;}
";" {return PONTOVIRGULA;}
"," {return VIRGULA;}
"(" {return ABREPARENTESE;}
")" { return FECHAPARENTESE;}
"[" {return ABRECOLCHETE;}
"]" {return FECHACOLCHETE;}
"{" {return ABRECHAVE;}
"}" {return FECHACHAVE;}


"int" {
    //Armazena valores inteiros em uma tabela

    char nomeAtributo[100];
    scanf("%s", nomeAtributo);
    
    // Verifique se o atributo já está na tabela de símbolos
    int i;
    for (i = 0; i < proximoIndice; i++) {
        if (strcmp(tabelaSimbolos[i].nome, nomeAtributo) == 0) {
            return ERROR;
        }
    }
    
    if (i == proximoIndice) {
        // Atributo não encontrado na tabela de símbolos, leia o valor
        int valorAtributo;
        scanf("%d", &valorAtributo);
        
        // Adicione o atributo à tabela de símbolos
        tabelaSimbolos[proximoIndice].nome = strdup(nomeAtributo);
        tabelaSimbolos[proximoIndice].valor = valorAtributo;
        proximoIndice++; // Avance para o próximo índice disponível
    }
 }

"/*" {
    // Iniciar o estado de comentário e ignorar tudo até encontrar "*/"
    BEGIN(comentario);
}

<comentario>{
    "*/" {
        // Finalizar o estado de comentário
        BEGIN(INITIAL);
    }
    [^*]+    ; // Ignorar outros caracteres dentro de um comentário
    "*"      ; // Ignorar "*" solto dentro de um comentário
 \n       ; // Ignorar quebras de linha dentro de um comentário
}

"/*" {
    // Iniciar o estado de comentário
    BEGIN(comentario);
}

<comentario>"/*" {
    // Comentário aninhado, incrementar contadores ou tratar como erro
}

<comentario>\n {
    // Ignorar quebras de linha dentro de um comentário
}

<comentario>. {
    // Ignorar outros caracteres dentro de um comentário
}


<<EOF>> {
    if (YY_START == comentario) {
        // ERROR: Comentário não foi fechado corretamente
         fprintf(stderr, "ERROR, linha %d: Comentário não foi fechado corretamente\n", yylineno);
	yylineno++;
        exit(1); // Encerrar o programa com erro
    }
    // Encerrar o programa normalmente se não estiver em um comentário
    exit(0);
}

[0-9][0-9]* {
    printf("(%s, CONSTANTE)\n", yytext);
}

[a-zA-Z][a-zA-Z]* {
    printf("(%s, ID)\n", yytext);
}

. {
    printf("(%s, ERROR, linha %d)\n", yytext, yylineno);
    int i;
    for (i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') {
            yylineno++;
        }
    }
}

[ \t]+ /* ignora */  
[\r\n]+ /*ignora */

%%


int main() {
    int token;
    
    while ((token = yylex())) {
        switch (token) {
            case IF:
                printf("(if, IF)\n");
                break;
            case ELSE:
                printf("(else, ELSE)\n");
                break;
            case INT:
                printf("(int, INT)\n");
                break;
            case RETURN:
                printf("(return, RETURN)\n");
                break;
            case VOID:
                printf("(void, VOID)\n");
                break;
            case WHILE:
                printf("(while, WHILE)\n");
                break;
            case MENOR:
                printf("(< relop LT)\n");
                break;
            case MAIOR:
                printf("(> relop GT)\n");
                break;
            case IGUAL:
                printf("(== relop EQ)\n");
                break;
            case MENORIGUAL:
                printf("(<= relop LE)\n");
                break;
            case MAIORIGUAL:
                printf("(>= relop GE)\n");
                break;
            case DIFERENTE:
                printf("(!=, relop NE)\n)");
                break;
	    case INCREMENTO:
		printf("(++, especial INCR)\n");
		break;
            case DECREMENTO:
		printf("(--, especial DECR)\n");
		break;
	    case SOMA:
		printf("(+, arit SUM)\n");
		break;
	    case SUBTRACAO:
		printf("(-, arit SUB)\n");
		break;
	    case DIVISAO:
		printf("(/, arit DIV)\n");
		break;
	    case MULTIPLICACAO:
		printf("(*, arit MT)\n");
		break;
	    case ATRIBUICAO:
		printf("(=, atribuicao ASSIGN)\n");
		break;
	    case PONTOVIRGULA:
		printf("(;, especial SC)\n");
		break;
	    case VIRGULA:
		printf("(,, especial COMMA)\n");
		break;
	    case ABREPARENTESE:
		printf("((, especial OP)\n");
		break;
	    case FECHAPARENTESE:
		printf("(), especial CP)\n");
		break;
            case ABRECOLCHETE:
		printf("([, especial OC)\n");
		break;
	    case FECHACOLCHETE:
		printf("(], especial CC)\n");
		break;
            case ABRECHAVE:
		printf("({, especial OCB)\n");
		break;
	    case FECHACHAVE:
		printf("(}, especial CCB)\n");
		break;
	    
            /* Outros casos para tokens */
            default:
                printf("Token não reconhecido\n");
                break;
        }
    }
    
    return 0;
}
