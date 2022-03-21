/* Define que define se essa versão do code é para testes e desenvolvimento, ou para hospedagem.
NÃO RETIRAR O COMENTÁRIO SE VOCÊ NÃO SABE OS RESULTADOS DISSO! */
//#define FARWEB_LIVE


// Define se o servidor vai estar listado na hub do SS13 ou do Farweb. Só funcionará se o define acima estiver ativado também.
//#define SS13_HUB

#ifdef FARWEB_LIVE
#warn FARWEB_LIVE IS DEFINED
#endif

#ifdef SS13_HUB
#warn SS13_HUB IS DEFINED
#endif