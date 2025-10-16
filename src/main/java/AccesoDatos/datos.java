package Accesodatos;

/**
 *
 * @author esteb
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class datos {
    
      private Connection conn;

    public Connection getConn() {
        return conn;
    }



    public datos() {

    }

    public datos(String URL, String USER, String PASSWORD) throws SQLException {
        conn = DriverManager.getConnection(URL, USER, PASSWORD);
    }

    
}
