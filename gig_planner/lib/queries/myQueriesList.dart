
String myquery =
""" 
  SELECT 
    * 
  from 
    users u 
  where 
    id < '@idmax'
""";