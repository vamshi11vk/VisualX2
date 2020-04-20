class Task {
  final String colorval;
  final String task;
  final int taskvalue;

  Task(this.colorval, this.task, this.taskvalue);
  Task.fromMap(Map<String,dynamic> map)
      :assert(map['colorval']!=null),
        assert(map['task']!=null),
        assert(map['taskvalue']!=null),
        colorval=map['colorval'],
        task=map['task'],
        taskvalue=map['taskvalue'];
//@override
//String toString()=> "Record<$colorval$task:$taskvalue>";
}
class Branchwise {
  final String colorval;
  final String task;
  final int value;

  Branchwise(this.colorval, this.task, this.value);
  Branchwise.fromMap(Map<String,dynamic> map)
      :assert(map['colorval']!=null),
        assert(map['task']!=null),
        assert(map['value']!=null),
        colorval=map['colorval'],
        task=map['task'],
        value=map['value'];
//@override
//String toString()=> "Record<$colorval$task:$taskvalue>";
}
class TCBranchwise {
  final String colorval;
  final String task;
  final int value;

  TCBranchwise(this.colorval, this.task, this.value);
  TCBranchwise.fromMap(Map<String,dynamic> map)
      :assert(map['colorval']!=null),
        assert(map['task']!=null),
        assert(map['value']!=null),
        colorval=map['colorval'],
        task=map['task'],
        value=map['value'];
//@override
//String toString()=> "Record<$colorval$task:$taskvalue>";
}
class CETBranchwise {
  final String colorval;
  final String task;
  final int value;

  CETBranchwise(this.colorval, this.task, this.value);
  CETBranchwise.fromMap(Map<String,dynamic> map)
      :assert(map['colorval']!=null),
        assert(map['task']!=null),
        assert(map['value']!=null),
        colorval=map['colorval'],
        task=map['task'],
        value=map['value'];
//@override
//String toString()=> "Record<$colorval$task:$taskvalue>";
}
class ECBranchwise {
  final String colorval;
  final String task;
  final int value;

  ECBranchwise(this.colorval, this.task, this.value);
  ECBranchwise.fromMap(Map<String,dynamic> map)
      :assert(map['colorval']!=null),
        assert(map['task']!=null),
        assert(map['value']!=null),
        colorval=map['colorval'],
        task=map['task'],
        value=map['value'];
//@override
//String toString()=> "Record<$colorval$task:$taskvalue>";
}
class User {
  final String xaxis;
  final int yaxis;

  User(this.xaxis, this.yaxis);
}