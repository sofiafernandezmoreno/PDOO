/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;

import java.util.*;

/**
 *
 * @author sofiafernandezmoreno
 */
public class Tablero {
    private ArrayList<Casilla> casillas;
    private Casilla carcel;

    public Tablero() {
        inicializar();
    }

   

    Casilla getCarcel() {
        return carcel;
    }
    ArrayList<Casilla> getCasillas(){
        return casillas;
    }
    
    @Override
    public String toString() {
        return "Tablero{" + "casillas=" + casillas + ", carcel=" + carcel + '}';
    }
    
    private void inicializar(){
        casillas = new ArrayList<Casilla>();
        //No son calles
        casillas.add(new OtraCasilla(0,1000,TipoCasilla.SALIDA));
        casillas.add(new OtraCasilla(1,0,TipoCasilla.PARKING)); // Parking
        casillas.add(new OtraCasilla(2,350,TipoCasilla.IMPUESTO)); // Impuesto
        casillas.add(new OtraCasilla(3,0,TipoCasilla.JUEZ)); // Juez
        casillas.add(new OtraCasilla(4,0,TipoCasilla.SORPRESA));//Sorpresa
        casillas.add(new OtraCasilla(5,250,TipoCasilla.SORPRESA));
        casillas.add(new OtraCasilla(6,200,TipoCasilla.SORPRESA));
        casillas.add(new OtraCasilla(7,0,TipoCasilla.CARCEL)); // Cárcel
       
        
        //Calles
                
        casillas.add(new Calle(8,new TituloPropiedad("Calle Finisterre", 600,50,(float)0.2, 200, 250)));
        casillas.add(new Calle(9,new TituloPropiedad("Calle Loteria",700 ,100,(float)0.15, 150, 750)));
        casillas.add(new Calle(10,new TituloPropiedad("Calle Killismo",500, 70,(float)0.1, 220, 650)));
        casillas.add(new Calle(11,new TituloPropiedad("Calle Penitencia",550, 80,(float)0.2, 250, 550)));
        casillas.add(new Calle(12,new TituloPropiedad("Calle Maria Antonieta",750, 60,(float)0.1, 600, 350)));
        casillas.add(new Calle(13,new TituloPropiedad("Calle Cacha",630, 75,(float)0.15, 1000, 450)));
        casillas.add(new Calle(14,new TituloPropiedad("Calle ACDC",550, 90,(float)0.17, 900, 300)));
        casillas.add(new Calle(15,new TituloPropiedad("Calle Lucrecia",600, 55,(float)0.2, 500, 500)));
        casillas.add(new Calle(16,new TituloPropiedad("Calle Orgullo",700, 85,(float)0.2, 400, 400)));
        casillas.add(new Calle(17,new TituloPropiedad("Calle Capilla Ardiente",700, 95,(float)0.1, 600, 350)));
        casillas.add(new Calle(18,new TituloPropiedad("Calle Melancolía",600, 65,(float)0.18, 750, 250)));
        casillas.add(new Calle(19,new TituloPropiedad("Calle Crazy",600, 70,(float)0.1, 500, 600)));
    
        carcel = casillas.get(7);   //el objeto es el mismo
    }
    
    boolean esCasillaCarcel(int numeroCasilla){
        boolean encontrado = false;
        if(this.carcel.getNumeroCasilla() == numeroCasilla)
            encontrado = true;
        return encontrado;
    }
    
    
    
    
    Casilla obtenerCasillaNumero(int numeroCasilla)throws NumberFormatException{
        if(this.casillas.size() > numeroCasilla ){ 
            return this.casillas.get(numeroCasilla);
        }
        else{
            throw new NumberFormatException("no hay casillas en la posicion numeroCasilla, obtenerCasillaNumero ");
        }
    }
    
     
     
     
     Casilla obtenerCasillaFinal(Casilla casilla, int desplazamiento){
        int casilla_llegada;
        casilla_llegada= (casilla.getNumeroCasilla()+desplazamiento)%casillas.size();
        return casillas.get(casilla_llegada);
        
    }
    
    
        
    
    
}
