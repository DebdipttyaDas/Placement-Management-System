import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBUtil {

    private static String url;
    private static String username;
    private static String password;

    static {

        try {
        	
        	Class.forName("com.mysql.cj.jdbc.Driver");  
        	

            Properties prop = new Properties();

            InputStream input = DBUtil.class.getClassLoader()
                    .getResourceAsStream("db.properties");
            
            if (input == null) {
                throw new RuntimeException("db.properties file not found.");
            }

            prop.load(input);

            url = prop.getProperty("url");
            username = prop.getProperty("username");
            password = prop.getProperty("password");            

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {

        return DriverManager.getConnection(url, username, password);

    }
}