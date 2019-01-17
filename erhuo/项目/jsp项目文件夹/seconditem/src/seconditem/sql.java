package seconditem;

import java.sql.*;

public class sql{
	private String sql;
	private ResultSet rs;
	private int i;
	
	public void executeQuery(String sql,int type) {
		switch(type)
		{
		case 0://query
			try {
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
				Statement stmt=conn.createStatement();
				this.rs=stmt.executeQuery(sql);
			} catch (SQLException | ClassNotFoundException e) {
				e.printStackTrace();
			}
			break;
		case 1://update
			try {
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;DatabaseName=seconditem","chris","123456");
				Statement stmt=conn.createStatement();
				this.i=stmt.executeUpdate(sql);
			} catch (SQLException | ClassNotFoundException e) {
				e.printStackTrace();
			}
			break;
		}
	}
}
