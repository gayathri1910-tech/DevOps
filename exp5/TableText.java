import java.io.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
class Text_To_Table extends JFrame{
public void convertTextToTable(){
setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
setSize(400,300);
GridLayout g=new GridLayout(0,4);
setLayout(g);
try{
FileInputStream fis=new FileInputStream("./Table.txt");
Scanner sc=new Scanner(fis);
String[] arrayList;String str;
while(sc.hasNextLine()){
str=sc.nextLine();
arrayList=str.split(",");
for(String i:arrayList){
add(new Label(i));
}
}
}
catch(Exception e){
e.printStackTrace();
}
setVisible(true);
setTitle("Display Data in Table");
}
}
public class TableText{
public static void main(String[] args){
Text_To_Table tt=new Text_To_Table();
tt.convertTextToTable();
}
}




