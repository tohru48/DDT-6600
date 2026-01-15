namespace Game.Base.Events
{
    using System;

    public class GameServerEvent : RoadEvent
    {
        public static readonly GameServerEvent Started;
        public static readonly GameServerEvent Stopped;
        public static readonly GameServerEvent WorldSave;

        static GameServerEvent()
        {
            Started = new GameServerEvent("Server.Started");
            Stopped = new GameServerEvent("Server.Stopped");
            WorldSave = new GameServerEvent("Server.WorldSave");
        }

        protected GameServerEvent(string name)
            : base(name)
        {
        }
    }
}
