package com.qweib.cloud.utils;

import java.sql.*;


public class DBHelper {
	public static final String url = "jdbc:mysql://localhost:3306/";  
    public static final String name = "com.mysql.jdbc.Driver";  
    public static final String user = "root";  
    public static final String password = "123456";  
  
    public Connection conn = null;  
    public PreparedStatement pst = null; 
    public Statement stm = null;
    public DBHelper(String sql,String dbName) {  
        try {  
        	String url1 = url + dbName;
            Class.forName(name);//指定连接类型  
            conn = DriverManager.getConnection(url1, user, password);//获取连接  
            stm = conn.createStatement();
            stm.executeUpdate(sql);
            //pst = conn.prepareStatement(sql);//准备执行语句  
           
            
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
  
    public void close() {  
        try {  
            this.conn.close();  
            this.pst.close();  
        } catch (SQLException e) {  
            e.printStackTrace();  
        }  
    }  
    
    

}



