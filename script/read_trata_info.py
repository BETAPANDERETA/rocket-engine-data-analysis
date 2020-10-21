# ---------------------------------------------
# AUTOR: Leonardo Betancur A.K.A BETAPANDERETA|
# CONTACTO: <lbetancurd@unal.edu.co>          |
# ---------------------------------------------
import csv
from itertools import groupby
from tabulate import tabulate

def ord_imp_data(lista,titles):

    tabla = []

    for i in range(len(lista)):
        fila = []
        fila.append(i+1)
        fila.append(lista[i])
        tabla.append(fila)
    
    
    datos_tabla = tabulate(tabla, headers=titles, tablefmt="plain")
    print(datos_tabla)

    return tabla

def leer_datos(info,pos):
    # pos = fila límite de los datos que quiero leer
    linea = 0
    mseg =""
    data_sp = []

    for i in info:
            if linea>pos:
                break
            linea +=1

            for j in i:
                try: # Leo la fecha (específicamente el segundo) de la 1ra columna del csv
                    mseg = j[18] 
                    # concateno el segundo con el dato de la 2da columna del csv
                    # Esto para saber que dato se tomó en un mismo segundo                
                    data_sp.append(mseg+" "+i[1])
                except IndexError:
                    pass   
    return data_sp                

def group_data_rep(info):
    # Agrupo los datos de la lista "info" que en la hora (hora:minuto:segundo) 
    # terminan en el mismo segundo con el método "groupby" usando una función lambda
    # Más info en [1]
    data_dr = [list(l) for k, l in groupby(info,lambda a: a.split(' ')[0])]

    return data_dr

def clean_data(dirtinfo):

    data_final = []

    for i in dirtinfo:
        for j in i:

            rem = j[0]
            dato = [s.strip(rem) for s in i ]     # Remuevo caracter que no deseo - método strip [2]
            f_dato =  [float(ele) for ele in dato]# Capturo el dato sin el caracter indeseado [2]
    
        util_dato = round(sum(f_dato)/len(f_dato),2) # Sacó el promedio entre los datos repetidos
        data_final.append(util_dato)

    return data_final

def create_cleanData():
    # Basado en [3] Leyendo test_data
    with open("data/test_data_m2.csv") as file:
        
        reader =  csv.reader(file)
        data_sp = leer_datos(reader,51)

    data_dr = group_data_rep(data_sp)
    data_final = clean_data(data_dr)

    titles = ["t","Impulso"]
    data_clean = ord_imp_data(data_final,titles)

    #Basado en [4] Creando el csv limpio para R

    with open("data/clean_data_m2.csv","w",newline='') as f:
        
        escritor = csv.writer(f,delimiter=",")
        escritor.writerow(titles)

        for i in range(len(data_clean)):
            escritor.writerow(data_clean[i])

def create_data_sp():
    
    with open("data/test_data_m2.csv") as file:
        
        reader =  csv.reader(file)
        data_sp = []
        linea = 0

        for row in reader:

            data_sp.append(float(row[1]))
            print("Dato["+str(linea)+"]:"+str(row[1]))

            if linea>51:
                break

            linea +=1
    titles = ["t","Impulso"]
    data_sp_csv = ord_imp_data(data_sp,titles)
    
    with open("data/dirt_data_m2.csv","w",newline='') as f:
        
        escritor = csv.writer(f,delimiter=",")
        escritor.writerow(titles)

        for i in range(len(data_sp_csv)):
            escritor.writerow(data_sp_csv[i])

def main():
    create_cleanData()
    create_data_sp()

if __name__ == "__main__":
    main()

# ---------------------------------------------
#                   REFERENCIAS                |
# ---------------------------------------------
# [1] https://www.geeksforgeeks.org/python-grouping-similar-substrings-in-list/
# [2] https://stackoverflow.com/questions/47301795/removing-special-characters-from-a-list-of-items-in-python
# [3] https://www.youtube.com/watch?v=efSjcrp87OY
# [4] https://youtu.be/s1XiCh-mGCA , https://sopython.com/canon/97/writing-csv-adds-blank-lines-between-rows/