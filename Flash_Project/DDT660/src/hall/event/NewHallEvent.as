package hall.event
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class NewHallEvent extends Event
   {
      
      public static const SHOWBUFFCONTROL:String = "showbuffcontrol";
      
      public static const UPDATETITLE:String = "newhallupdatetitle";
      
      public static const BTNCLICK:String = "newhallbtnclick";
      
      public static const PLAYERINFO:String = "newhallplayerinfo";
      
      public static const OTHERPLAYERINFO:String = "newhallotherplayerinfo";
      
      public static const PLAYEREXIT:String = "newhallplayerexit";
      
      public static const PLAYERMOVE:String = "newhallplayermove";
      
      public static const ADDPLAYE:String = "newhalladdplayer";
      
      public static const MODIFYDRESS:String = "newhallmodifydress";
      
      public static const PLAYERONLINE:String = "newhallplayeronline";
      
      public static const PLAYERHID:String = "newhallplayerhid";
      
      public static const PLAYERSHOW:String = "newhallplayershow";
      
      public static const UPDATETIPSINFO:String = "newhallsetplayertippos";
      
      public static const CANCELEMAILSHINE:String = "cancelemailshine";
      
      public static const SETSELFPLAYERPOS:String = "setselfplayerpos";
      
      public static const SHOWPETS:String = "showPets";
      
      public static const UPDATEPETS:String = "updatePets";
      
      public static const UPDATEPLAYERTITLE:String = "updatePlayerTitle";
      
      private var _pkg:PackageIn;
      
      private var _data:Array;
      
      public function NewHallEvent(type:String, pkg:PackageIn = null, data:Array = null)
      {
         super(type,bubbles,cancelable);
         this._pkg = pkg;
         this._data = data;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
   }
}

