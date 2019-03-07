/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;

/**
 *
 * @author sofiafernandezmoreno
 */
public abstract class Casilla {
    private int numeroCasilla;
    private int coste;
    
    
    public Casilla(int numeroCasilla, int coste) {
        this.numeroCasilla = numeroCasilla;
        this.coste = coste;
        
    }
  

    int getNumeroCasilla() {
        return numeroCasilla;
    }

    int getCoste() {
        return coste;
    }
    //Metodos de la clase abstracta porque Casilla está en cursiva
    protected abstract TipoCasilla getTipo();

    protected abstract TituloPropiedad getTitulo();
    
    protected abstract boolean soyEdificable();

    public void setCoste(int coste){
        this.coste = coste;
    }

    @Override
    public String toString() {
        String to_s = "";
        to_s += "nº " + numeroCasilla;
        return to_s;
    }
    
    
    
    

    
    
    
    
}
