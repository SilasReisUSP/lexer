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
        ERROR
     };
%}

%x comentario

%%

[ \t\n] ; // Ignorar espaços em branco e quebras de linha

"if"    { return IF; }
"else"  { return ELSE; }
"int"   {return INT;}
"return" {return RETURN;}
"void" { return VOID;}
"while" {return while;}
"<"  { return MENOR; }
">"  { return MAIOR; }
"="  { return IGUAL; }
"<="  { return MENORIGUAL; }
">="  { return MAIORIGUAL; }
"<>"  { return DIFERENTE; }

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

[0-9]+ {
    // Quando um número inteiro é encontrado, imprima-o
    printf("%s", yytext);
}

%%

int main() {
    int token;
    
    while ((token = yylex())) {
        switch (token) {
            case IF:
                printf("if\n");
                break;
            case ELSE:
                printf("else\n");
                break;
            case INT:
                printf("int\n");
                break;
            case RETURN:
                printf("return\n");
                break;
            case VOID:
                printf("void\n");
                break;
            case WHILE:
                printf("while\n");
                break;
            case MENOR:
                printf("< relop LT\n");
                break;
            case MAIOR:
                printf("> relop GT\n");
                break;
            case IGUAL:
                printf("= relop EQ\n");
                break;
            case MENORIGUAL:
                printf("<= relop LE\n");
                break;
            case MAIORIGUAL:
                printf(">= relop GE\n");
                break;
            case DIFERENTE:
                printf("<> relop NE\n");
                break;
            /* Outros casos para tokens */
            default:
                printf("Token não reconhecido\n");
                break;
        }
    }
    
    return 0;
}
