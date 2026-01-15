namespace Game.Base
{
    using System;

    public class Statistics
    {
        public static long BytesIn;
        public static long BytesOut;
        public static int MemAccCount;
        public static int MemCharCount;
        public static int MemMobCount;
        public static int MemPacketInObj;
        public static int MemPacketOutObj;
        public static int MemPlayerCount;
        public static int MemSpellHandlerObj;
        public static long PacketsIn;
        public static long PacketsOut;

        static Statistics()
        {
        }

        public Statistics()
        {
        }
    }
}
