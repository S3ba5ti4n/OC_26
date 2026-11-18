#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/* Procedimientos escritos en ensamblador (p10.asm) */
extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);

/* Posicion de cada bandera dentro del byte */
#define BIT_N 0   /* No cambio */
#define BIT_O 1   /* Diferencia de 1 grado */
#define BIT_T 2   /* Diferencia de 2 grados */
#define BIT_G 3   /* Diferencia mayor a 2 grados */
#define BIT_D 4   /* La temperatura bajo */
#define BIT_U 5   /* La temperatura subio */

#define SENSORES 2

/* Genera un numero entre -5 y 5 y se lo suma a cada sensor */
void update_temp(int *temps)
{
    int i;
    for (i = 0; i < SENSORES; i++) {
        temps[i] += (rand() % 11) - 5;
    }
}

/* Compara la ultima lectura con la nueva, actualiza banderas y ultima lectura */
void update_flags(int *temps, int *last_temps, unsigned char *flags)
{
    int i, dif, abs_dif;

    for (i = 0; i < SENSORES; i++) {
        dif = temps[i] - last_temps[i];
        abs_dif = (dif < 0) ? -dif : dif;

        flags[i] = 0;                       /* se limpian las banderas */

        if (dif > 0) set_bit(&flags[i], BIT_U);
        if (dif < 0) set_bit(&flags[i], BIT_D);

        if (abs_dif == 0)      set_bit(&flags[i], BIT_N);
        else if (abs_dif == 1) set_bit(&flags[i], BIT_O);
        else if (abs_dif == 2) set_bit(&flags[i], BIT_T);
        else                   set_bit(&flags[i], BIT_G);

        last_temps[i] = temps[i];
    }
}

/* Imprime los simbolos segun las banderas (se leen con get_bit) */
void imprimir_estado(unsigned char flags)
{
    char c;
    int n, i;

    if (get_bit(flags, BIT_N)) {
        printf("-");
        return;
    }

    c = get_bit(flags, BIT_U) ? '>' : '<';

    if (get_bit(flags, BIT_O))      n = 1;
    else if (get_bit(flags, BIT_T)) n = 2;
    else                            n = 3;   /* bandera G: 3 o mas grados */

    for (i = 0; i < n; i++)
        putchar(c);
}

int main(void)
{
    unsigned char banderas[SENSORES];
    int ultima_lectura[SENSORES];
    int tem_sensores[SENSORES];
    int i, opcion = 0;

    srand((unsigned int)time(NULL));

    /* Los sensores inician en 25 grados y sin cambio */
    for (i = 0; i < SENSORES; i++) {
        tem_sensores[i] = 25;
        ultima_lectura[i] = 25;
        banderas[i] = 0;
        set_bit(&banderas[i], BIT_N);
    }

    while (opcion != 2) {
        for (i = 0; i < SENSORES; i++) {
            /* \xc2\xb0 es el simbolo de grados en UTF-8 */
            printf("SENSOR %d: ~ %d \xc2\xb0" "C ", i + 1, tem_sensores[i]);
            imprimir_estado(banderas[i]);
            printf("\n");
        }
        printf("[1] Actualizar\n");
        printf("[2] Salir\n");
        printf("Seleccionar opcion: ");

        if (scanf("%d", &opcion) != 1) {
            while (getchar() != '\n');
            opcion = 0;
        }
        printf("\n");

        if (opcion == 1) {
            update_temp(tem_sensores);
            update_flags(tem_sensores, ultima_lectura, banderas);
        }
    }

    return 0;
}