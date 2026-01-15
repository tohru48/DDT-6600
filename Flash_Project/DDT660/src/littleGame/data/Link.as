package littleGame.data
{
   internal class Link
   {
      
      public var node:Node;
      
      public var cost:Number;
      
      public function Link(node:Node, cost:Number)
      {
         super();
         this.node = node;
         this.cost = cost;
      }
   }
}

