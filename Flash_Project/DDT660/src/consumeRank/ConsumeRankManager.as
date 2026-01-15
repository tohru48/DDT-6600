package consumeRank
{
   import consumeRank.data.ConsumeRankEvent;
   import consumeRank.data.ConsumeRankVo;
   import consumeRank.views.ConsumeRankView;
   import ddt.manager.SocketManager;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import wonderfulActivity.ActivityType;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.LeftViewInfoVo;
   
   public class ConsumeRankManager
   {
      
      private static var _instance:ConsumeRankManager;
      
      public var actId:String;
      
      public var status:int;
      
      public var xmlData:GmActivityInfo;
      
      public var view:ConsumeRankView;
      
      public var myConsume:int;
      
      public var rankList:Array;
      
      private var requestCount:int = 0;
      
      public function ConsumeRankManager()
      {
         super();
      }
      
      public static function get instance() : ConsumeRankManager
      {
         if(!_instance)
         {
            _instance = new ConsumeRankManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(ConsumeRankEvent.UPDATE,this.__updateInfo);
      }
      
      protected function __updateInfo(event:ConsumeRankEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var vo:ConsumeRankVo = null;
         var pkg:PackageIn = event.pkg;
         this.actId = pkg.readUTF();
         var isOpen:Boolean = pkg.readBoolean();
         var activityData:Dictionary = WonderfulActivityManager.Instance.activityData;
         var leftViewInfoDic:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         if(isOpen)
         {
            this.status = pkg.readInt();
            this.xmlData = activityData[this.actId];
            if(!this.xmlData)
            {
               ++this.requestCount;
               if(this.requestCount <= 5)
               {
                  SocketManager.Instance.out.requestWonderfulActInit(0);
               }
               return;
            }
            if(WonderfulActivityManager.Instance.actList.indexOf(this.actId) == -1)
            {
               leftViewInfoDic[this.actId] = new LeftViewInfoVo(ActivityType.CONSUME_RANK,"· " + this.xmlData.activityName,this.xmlData.icon);
               WonderfulActivityManager.Instance.addElement(this.actId);
            }
            this.rankList = [];
            count = pkg.readInt();
            for(i = 0; i <= count - 1; i++)
            {
               vo = new ConsumeRankVo();
               vo.userId = pkg.readInt();
               vo.name = pkg.readUTF();
               vo.vipLvl = pkg.readByte();
               vo.consume = pkg.readInt();
               this.rankList.push(vo);
            }
            this.myConsume = pkg.readInt();
            if(Boolean(this.view))
            {
               this.view.updateView();
            }
         }
         else
         {
            WonderfulActivityManager.Instance.removeElement(this.actId);
         }
      }
   }
}

