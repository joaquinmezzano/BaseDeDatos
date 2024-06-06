import java.sql.*;
import java.util.Scanner;

public class ProyectoCMV {
  public static void main(String[] args) {

	  Connection connection = null;

    try {
      String driver = "com.mysql.cj.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/ProyectoCMV";
      String username = "root";
      String password = "joaquin";

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
        System.out.println("4. Devolver actores que solo figuran en una pelicula");
        System.out.println("5. Listar las personas que han sido actores y directores");
        System.out.println("6. Listas los cines con la cantidad total de butacas");
        System.out.println("7. Consultas propias");
        System.out.println("8. Salir");
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
            int numero = 0, cantidad_butacas = 0;
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

              System.out.println("Número de sala: "+numero+" - Cantidad de butacas: "+cantidad_butacas
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
            query = "SELECT c.nombre, s.numero, s.cantidad_butacas FROM Cine c "+
            "LEFT JOIN Sala s ON c.nombre = s.nombre_cine ORDER BY c.nombre, "+
            "s.numero";
            statement = connection.prepareStatement(query);
            ResultSet result = statement.executeQuery();

            System.out.println("Cines con la información de sus salas");
            while(result.next()) {
              String nombreCine = result.getString("nombre");
              int numeroSala = result.getInt("numero");
              int cantidadButacas = result.getInt("cantidad_butacas");
              System.out.println("Cine: "+nombreCine+" - Número sala: "+numeroSala+" - Butacas en sala: "+cantidadButacas);
            }

            break;
          case 4:
            query = "SELECT nombre_protagonista " +
            "FROM Protagonista " +
            "JOIN Actuo ON Protagonista.nombre_protagonista = Actuo.nombre_p " +
            "GROUP BY nombre_protagonista " +
            "HAVING COUNT(Actuo.ident_pelicula) = 1";
            statement = connection.prepareStatement(query);
            result = statement.executeQuery();

            System.out.println("Actores que solo estuvieron en una pelicula");
            while(result.next()) {
              String nombre_protagonista = result.getString("nombre_protagonista");
              System.out.println("Actor: "+nombre_protagonista);
            }

            break;
          case 5:
            query = "SELECT DISTINCT nombre_director " +
                    "FROM Director " +
                    "JOIN Protagonista ON Director.nombre_director = Protagonista.nombre_protagonista " +
                    "UNION " +
                    "SELECT DISTINCT nombre_director " +
                    "FROM Director " +
                    "JOIN Reparto ON Director.nombre_director = Reparto.nombre_reparto";
            statement = connection.prepareStatement(query);
            result = statement.executeQuery();

            System.out.println("Personas que actuaron y dirigieron");
            while(result.next()) {
              nombre = result.getString("nombre_director");
              System.out.println("Nombre: "+nombre);
            }

            break;
          case 6:
            query = "SELECT Cine.nombre, SUM(Sala.cantidad_butacas) AS total_butacas " +
            "FROM Cine " +
            "JOIN Sala ON Cine.nombre = Sala.nombre_cine " +
            "GROUP BY Cine.nombre";
            statement = connection.prepareStatement(query);
            result = statement.executeQuery();

            System.out.println("Cines con butacas totales");
            while(result.next()) {
              String nombreCine = result.getString("nombre");
              int totalButacas = result.getInt("total_butacas");
              System.out.println("Cine: "+nombreCine+" - Butacas totales: "+totalButacas);
            }
            break;
          case 7:
            // Peliculas que duran mas de 1 hora y 45 minutos
            query = "SELECT titulo_español, duracion FROM Pelicula WHERE duracion > '01:45:00'";
            statement = connection.prepareStatement(query);
            result = statement.executeQuery();

            System.out.println("Peliculas que duran más de 01:45:00");
            while(result.next()) {
              String titulo = result.getString("titulo_español");
              Time duracion = result.getTime("duracion");
              System.out.println("Titulo: "+titulo+" - Duración: "+duracion);
            }
            System.out.println();

            // Peliculas entre 2010 y 2015
            query = "SELECT titulo_español, año_produccion FROM Pelicula WHERE año_produccion BETWEEN 2010 AND 2015";
            statement = connection.prepareStatement(query);
            result = statement.executeQuery();

            System.out.println("Peliculas entre 2010 y 2015");
            while(result.next()) {
              String titulo = result.getString("titulo_español");
              int añoP = result.getInt("año_produccion");
              System.out.println("Titulo: "+titulo+" - Año: "+añoP);
            }
            System.out.println();

            // Devuelve los títulos de distribución de las películas que tienen al menos un actor protagonista que ha actuado en más de 3 películas
            query = "SELECT titulo_distribucion FROM Pelicula WHERE id_pelicula IN (SELECT DISTINCT Actuo.ident_pelicula"+
              " FROM Actuo JOIN Protagonista ON Actuo.nombre_p = Protagonista.nombre_protagonista WHERE "+
              "Protagonista.nombre_protagonista IN (SELECT nombre_protagonista FROM Actuo GROUP BY "+
              "nombre_protagonista HAVING COUNT(ident_pelicula) > 3))";
            statement = connection.prepareStatement(query);
            result = statement.executeQuery();

            System.out.println("Películas con actores protagonistas que han actuado en más de 3 películas:");
            while(result.next()) {
              String titulo = result.getString("titulo_distribucion");
              System.out.println("Título: "+titulo);
            }

            break;
          case 8:
            menu = true;
            System.out.println("¡Adios!");
            break;
          default:
            System.out.println("Opción no válida. Intente de nuevo.");
        }
      }

      scanner.close();
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
