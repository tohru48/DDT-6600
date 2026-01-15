namespace Game.Base.Events
{
    using System;

    public class ScriptEvent : RoadEvent
    {
        public static readonly ScriptEvent Loaded;
        public static readonly ScriptEvent Unloaded;

        static ScriptEvent()
        {
            Loaded = new ScriptEvent("Script.Loaded");
            Unloaded = new ScriptEvent("Script.Unloaded");
        }

        protected ScriptEvent(string name)
            : base(name)
        {
        }
    }
}
