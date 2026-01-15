package treasurePuzzle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TreasurePuzzleHelpContentItem extends Sprite
   {
      
      private var bg:Bitmap;
      
      private var titleText:FilterFrameText;
      
      private var contentText:FilterFrameText;
      
      public function TreasurePuzzleHelpContentItem(type:int, title:String, content:String)
      {
         super();
         if(type == 0)
         {
            this.bg = ComponentFactory.Instance.creat("treasurePuzzle.redTitleBg");
            this.titleText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.redTitle");
         }
         else if(type == 1)
         {
            this.bg = ComponentFactory.Instance.creat("treasurePuzzle.blueTitleBg");
            this.titleText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.blueTitle");
         }
         else if(type == 2)
         {
            this.bg = ComponentFactory.Instance.creat("treasurePuzzle.yellowTitleBg");
            this.titleText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.yellowTitle");
         }
         this.contentText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.rewardContentText");
         this.titleText.text = title;
         this.contentText.text = content;
         addChild(this.bg);
         addChild(this.titleText);
         addChild(this.contentText);
      }
   }
}

