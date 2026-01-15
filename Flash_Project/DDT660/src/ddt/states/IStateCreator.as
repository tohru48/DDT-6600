package ddt.states
{
   public interface IStateCreator
   {
      
      function create(param1:String, param2:int = 0) : BaseStateView;
      
      function createAsync(param1:String, param2:Function, param3:int = 0) : void;
   }
}

