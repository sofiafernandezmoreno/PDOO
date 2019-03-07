/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vistatextualqytetet;

import java.util.ArrayList;
import java.util.Scanner;
import modeloqytetet.Qytetet;
import controladorqytetet.*;

/**
 *
 * @author sofiafernandezmoreno
 */
public class VistaTextualQytetet {
    public static Qytetet modelo;
    public static ControladorQytetet controlador;
    public VistaTextualQytetet() {
        
        modelo = Qytetet.getInstance();
        controlador = ControladorQytetet.getInstance();
    }
    
    public ArrayList<String> obtenerNombreJugadores(){
        ArrayList<String> nombres = new ArrayList();
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Introduce el numero de jugadores: ");
        int n = sc.nextInt();
        if(n <= modelo.MAX_JUGADORES && n >= 2){
            String s;
            s = sc.nextLine();
            for (int i = 0 ; i < n ; i++ ){
                System.out.print("Nombre jugador " + i + ": ");
                s = sc.nextLine();
                nombres.add(s);
            }
        }
        return nombres;
    }
    
    public int elegirCasilla(int opcionMenu){
        ArrayList<Integer> casillas = controlador.obtenerCasillasValidas(opcionMenu);
        ArrayList<String> nuevasCasillas = new ArrayList<>();
        
        if(casillas.isEmpty())//Si la lista está vacía
            return -1;
        else{
            System.out.print("\nIndique la casilla que desea cambiar: ");
            for(int i = 0; i < casillas.size(); ++i){
                System.out.print(casillas.get(i) + " ");
                nuevasCasillas.add(Integer.toString(casillas.get(i)));
            }
            
            return Integer.parseInt(this.leerValorCorrecto(nuevasCasillas));
        }
    }
    
    public String leerValorCorrecto(ArrayList<String> valoresCorrectos){
        String orden = "";
        boolean correcto = false;
        Scanner sc = new Scanner(System.in);        
        
        while(!correcto){
            System.out.print("\nIntroduce tu orden: ");
            orden = sc.nextLine();
            
            for(int i = 0; i < valoresCorrectos.size() && !correcto; ++i){
                if(orden.equals(valoresCorrectos.get(i)))
                    correcto = true;
            }
            
            if(!correcto)
                System.out.println("Orden no válida, vuelve a intentarlo.");
        }
        
        return orden;
    }
    
    public int elegirOperacion(){
        ArrayList<Integer> op = controlador.obtenerOperacionesJuegoValidas();
        ArrayList<String> ops = new ArrayList<>();
        
        System.out.print("\nÓrdenes disponibles: ");
        for(int num: op){
            System.out.print(OpcionMenu.values()[num] + "(" + num + ")" + " ");
            ops.add(Integer.toString(num));
        }
        
        
        return Integer.parseInt(this.leerValorCorrecto(ops));
    }
    
    public static void main(String []args) throws Exception{
        VistaTextualQytetet ui = new VistaTextualQytetet();
        controlador.setNombreJugadores(ui.obtenerNombreJugadores());
        int operacionElegida, casillaElegida = 0;
        boolean necesitaElegirCasilla;
        
        do{
            System.out.println("Estado actual: "+ modelo.getEstadoJuego());
            operacionElegida = ui.elegirOperacion();
            necesitaElegirCasilla = controlador.necesitaElegirCasilla(operacionElegida);
            
            if (necesitaElegirCasilla)
                casillaElegida = ui.elegirCasilla(operacionElegida);
            
            if (!necesitaElegirCasilla || casillaElegida >= 0)
                System.out.println(controlador.realizarOperacion(operacionElegida,casillaElegida));
        }while(true);
    }
    
}

