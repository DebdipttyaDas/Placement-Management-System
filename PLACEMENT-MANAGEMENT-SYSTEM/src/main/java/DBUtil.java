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
                    .getResourceAsStream("config.properties");
            if (input == null) {
                throw new RuntimeException("config.properties file not found.");
            }
            prop.load(input);

            String host = prop.getProperty("AIVEN_HOST");
            String port = prop.getProperty("AIVEN_PORT");
            String dbName = prop.getProperty("AIVEN_DATABASE");
            username = prop.getProperty("AIVEN_USERNAME");
            password = prop.getProperty("AIVEN_PASSWORD");
            String sslEnabled = prop.getProperty("SSL_ENABLED");

            url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?sslMode=" + 
                  ("true".equalsIgnoreCase(sslEnabled) ? "REQUIRED" : "DISABLED");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {

        return DriverManager.getConnection(url, username, password);

    }
}