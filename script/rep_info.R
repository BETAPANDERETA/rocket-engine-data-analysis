# ---------------------------------------------
# AUTOR: Leonardo Betancur A.K.A BETAPANDERETA|
# CONTACTO: <lbetancurd@unal.edu.co>          |
# ---------------------------------------------

library(extrafont) # Cargando fonts --> Revisar disponibles con windosFonts()
library(ggplot2)   # Gráficos 
library(mgcv)      #---> Usar GAM

#_______________________________________________
#                 DATOS PROCESADOS_M1            |
#_______________________________________________

#data_csv = "data/clean_data.csv"
#data_util = read.table(data_csv,header = TRUE,sep=",")
#data_y = c(data_util$Impulso)
#data_x = c(data_util$t)
#_______________________________________________
#                 DATOS SIN PROCESAR_M1         |
#_______________________________________________

data_csv = "data/dirt_data.csv"
data_util = read.table(data_csv,header = TRUE,sep=",")
data_y = c(data_util$Impulso)
data_x = c(data_util$t)

gam_curve = gam(data_y ~ s(data_x))                         # Regresión GAM
loes_curve = loess(data_y ~ data_x)                         # Regresión LOESS
sm_curve = lm(data_y ~ poly(data_x,degree = 6,raw = TRUE))  # Regresión polinomial

print(summary(sm_curve)) # Stats de la regresión polinomial

#_______________________________________________
#               GRÁFICOS CON GGPLOT2            |
#_______________________________________________|

plot_gg = function(data,x,y,lb_x,lb_y,title){ # Gráficos usando ggplot2
      
      g_p = 6 # Grado de polinomio - regresión

      ggplot(data,aes(x=x,y=y))+
      ggtitle(title)+
      theme_bw()+
      geom_point()+
      geom_line(aes(colour="Registros"))+
      geom_hline(yintercept=0)+
      geom_smooth( # Regresión GAM
            method = "gam",
            se = FALSE,
            linetype = "dashed",
            aes(colour="Regresión GAM")
      )+
      geom_smooth( # Regresión LOESS
            method = "loess",
            se = FALSE,
            linetype = "twodash",
            aes(colour="Regresión LOESS")
      )+
      geom_smooth( # Regresión polinomial
            method = "lm",
            formula = y ~ poly(x,degree = g_p,raw = TRUE),
            se = FALSE,
            aes(colour="Regresión polinómica")
      )+ 
      stat_smooth( # Área bajo la curva basado en [1]
            geom = 'area',
            method = 'lm',
            formula = y ~ poly(x,degree = g_p,raw = TRUE),
            alpha = .4, aes(fill = "Impulso Total")
      ) +
      scale_fill_manual(
            name="Conv. área sombreada",
            values="pink"
      )+
      theme(
            text=element_text(family="RomanS_IV25"),
            plot.title = element_text(color="red", size=14,family = "Technic"),
            legend.title = element_text(size=10)
      )+
      xlab(lb_x)+ylab(lb_y)+ # leyendas en el plot tomado de [2]
      scale_colour_manual(
            name="Convenciones lineas",
            values=c("grey", "black","red","blue")
      )
}

#_______________________________________________
#               GRÁFICOS CON R                  |
#_______________________________________________|

plot_r = function(x,y,r_pol,r_gam,r_loess){
      plot(
            x,y,
            bty = "l",
            pch = 16,
            cex = .9
            )

      legend("topright", 
            legend=c("Regresión P(x)", "Regresión GAM","Regresión LOESS"),
            col=c("blue", "green","red"),
            lty=1,lwd = 2, cex=0.8
            )

      lines(predict(r_pol), # Regresión polinomial
            col = "blue",
            lwd = 2)

      lines(predict(r_gam), # Regresión GAM
            col = "green",
            lwd = 2)

      lines(predict(r_loess), # Regresión LOESS
            col = "red",
            lwd = 2)
}

#_______________________________________________
#               GRAFICANDO                      |
#_______________________________________________|

lab_g =c("Tiempo (s)","Gramos - fuerza (g)","Curva de impulso")
graf_gg = plot_gg(data_util,data_x,data_y,lab_g[1],lab_g[2],lab_g[3])

print(graf_gg)

#_______________________________________________
#               REFERENCIAS                     |
#_______________________________________________|

# [1] https://stackoverflow.com/questions/40133833/smooth-data-for-a-geom-area-graph
# [2] https://stackoverflow.com/questions/36276240/how-to-add-legend-to-geom-smooth-in-ggplot-in-r
# Diferencia entre poly(raw = TRUE) y I(x):
# [3] https://stackoverflow.com/questions/19484053/what-does-the-r-function-poly-really-do