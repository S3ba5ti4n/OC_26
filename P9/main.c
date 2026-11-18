#include <stdio.h>

#define MAX 5

extern int maximo(int *arr, int len);
extern int minimo(int *arr, int len);
extern int sumatoria(int *arr, int len);

int main()
{
    int arr[MAX];
    int n = 0;
    int i;

    printf("Cuantos numeros enteros quieres capturar (1 a %d)? ", MAX);
    scanf("%d", &n);

    if (n < 1) n = 1;
    if (n > MAX) n = MAX;

    for (i = 0; i < n; i++) {
        printf("Elemento [%d]: ", i);
        scanf("%d", &arr[i]);
    }

    printf("\nElementos guardados en el arreglo:\n");
    for (i = 0; i < n; i++) {
        printf("arr[%d] = %d\n", i, arr[i]);
    }

    printf("\nMaximo   = %d\n", maximo(arr, n));
    printf("Minimo   = %d\n", minimo(arr, n));
    printf("Sumatoria = %d\n", sumatoria(arr, n));

    return 0;
}