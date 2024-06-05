import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class ProyectoCMV {
  public static void main(String[] args) {

	  Connection connection = null;

    try {
      String driver = "com.mysql.cj.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/ProyectoCMV";
      String username = "root";
      String password = "root";

      // Cargamos el driver, conección con la base de datos y para trabajar con transacciones.
      Class.forName(driver);
      connection = DriverManager.getConnection(url, username, password);
      connection.setAutoCommit(false); 

      // Comenzamos el loop para utilizar de menu
      boolean menu = false;
      Scanner scanner = new Scanner(System.in);
      boolean insertado = false;
      String query;
      PreparedStatement statement;
      int res;

      while(!menu) {
        System.out.println();
        System.out.println("Menú de opciones");
        System.out.println("1. Insertar un cine");
        System.out.println("2. Insertar una sala en un cine");
        System.out.println("3. Listar los cines con la información de sus salas");
        System.out.println("4. Salir");
        System.out.print("Seleccione una de las opciones: ");
        int choice = scanner.nextInt();
        scanner.nextLine();
        System.out.println();

        switch (choice) {
          case 1:
            query = "INSERT INTO Cine (NOMBRE,DIRECCION,TELEFONO) VALUES (?,?,?)";
            statement = connection.prepareStatement(query);
            insertado = false;
            String nombre = "", dir = "", tel = "";
            res = 0;
      
            while(!insertado) {
              System.out.print("Inserte el nombre del nuevo cine: ");
              nombre = scanner.nextLine();
              System.out.print("Inserte la direcciòn del nuevo cine: ");
              dir = scanner.nextLine();
              System.out.print("Inserte el telefono del nuevo cine: ");
              tel = scanner.nextLine();
      
              System.out.println("Nombre: "+nombre+" - Direcciòn: "+dir+" - Telefono: "+tel);
              System.out.println("¿Los datos son correctos? SI(1)");
              res = scanner.nextInt();
              scanner.nextLine();
              if (res == 1) {
                insertado = true;
              }
            }
      
            statement.setString(1, nombre);
            statement.setString(2, dir);
            statement.setString(3, tel);
            statement.executeUpdate();

            //  Comiteo los cambios a la base de datos
            connection.commit();

            System.out.println("Cine agregado correctamente.");

            break;
          case 2:
            insertado = false;
            int numero = 0, numeroF = 0, cantidad_butacas = 0;
            String nombre_cine = "";
            res = 0;

            while(!insertado) {
              System.out.print("Inserte la cantidad de butacas de la sala: ");
              cantidad_butacas = scanner.nextInt();
              scanner.nextLine();
              System.out.print("Inserte el nombre del cine al que pertenece la sala: ");
              nombre_cine = scanner.nextLine();
            
              // Obtener el número de sala a crear
              query = "SELECT COUNT(numero) AS max_numero FROM Sala";
              statement = connection.prepareStatement(query);
              ResultSet result = statement.executeQuery();
              if (result.next()) {
                numero = result.getInt("max_numero")+1;
              } else {
                numero = 1;
              }

              // Obtener el número a mostrar, el no real
              query = "SELECT COUNT(numero) AS max_numero FROM Sala WHERE nombre_cine = ?";
              statement = connection.prepareStatement(query);
              statement.setString(1, nombre_cine);
              result = statement.executeQuery();
              if (result.next()) {
                numeroF = result.getInt("max_numero")+1;
              } else {
                numeroF = 1;
              }

              System.out.println("Número de sala: "+numeroF+" - Cantidad de butacas: "+cantidad_butacas
              +" - Nombre del cine: "+nombre_cine);
              System.out.println("¿Los datos son correctos? SI(1)");
              res = scanner.nextInt();
              scanner.nextLine();
              if (res == 1) {
                insertado = true;
              }
            }

            query = "INSERT INTO Sala (NUMERO, CANTIDAD_BUTACAS, NOMBRE_CINE) VALUES (?, ?, ?)";
            statement = connection.prepareStatement(query);

            statement.setInt(1, numero);
            statement.setInt(2, cantidad_butacas);
            statement.setString(3, nombre_cine);
            statement.executeUpdate();
            connection.commit();

            System.out.println("Sala agregada correctamente.");

            break;
          case 3:
            query = "SELECT c.nombre, s.numero, s.cantidad_butacas FROM Cine c LEFT JOIN Sala s ON c.nombre = s.nombre_cine ORDER BY c.nombre, s.numero";
            statement = connection.prepareStatement(query);
            ResultSet result = statement.executeQuery();

            System.out.println("Cines con la información de sus salas");
            Map<String, Integer> cineSalaMap = new HashMap<>();
            while(result.next()) {
              String nombreCine = result.getString("nombre");
              int cantidadButacas = result.getInt("cantidad_butacas");
              
              if (cineSalaMap.containsKey(nombreCine)) {
                cineSalaMap.put(nombreCine, cineSalaMap.get(nombreCine)+1);
              } else {
                cineSalaMap.put(nombreCine, 1);
              }

              int numeroSalaMostrar = cineSalaMap.get(nombreCine);
              System.out.println("Cine: "+nombreCine+" - Número sala: "+numeroSalaMostrar+" - Butacas en sala: "+cantidadButacas);
            }

            break;
          case 4:
            menu = true;
            System.out.println("¡Adios!");
            break;
          default:
            System.out.println("Opción no válida. Intente de nuevo.");
        }
      }

      connection.close();
     
    } catch(ClassNotFoundException cnfe) {
        System.err.println("Error loading driver: " + cnfe);
    } catch(SQLException sqle) {
        try	{
        // como se produjo una excepcion en el acceso a la base de datos se debe hacer el rollback	
        // Thread.sleep (20*1000); 	
         System.err.println("antes rollback: " + sqle);
         connection.rollback();
         System.err.println("Error Se produjo una Excepcion accediendo a la base de datoas: " + sqle);
         sqle.printStackTrace();
        } 
        catch(Exception e) {
          //System.err.println("Error Ejecutando el rollback de la transaccion: " + e.getMessage());
          e.printStackTrace();
        }
    }
  }
}
