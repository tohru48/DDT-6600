namespace Game.Base
{
    using System;

    public class WeakRef : WeakReference
    {
        private static readonly NullValue NULL;

        static WeakRef()
        {
            NULL = new NullValue();
        }

        public WeakRef(object target)
            : base((target == null) ? NULL : target)
        {
        }

        public WeakRef(object target, bool trackResurrection)
            : base((target == null) ? NULL : target, trackResurrection)
        {
        }

        public override object Target
        {
            get
            {
                object target = base.Target;
                if (target != NULL)
                {
                    return target;
                }
                return null;
            }
            set
            {
                base.Target = (value == null) ? NULL : value;
            }
        }

        private class NullValue
        {
            public NullValue()
            {
            }
        }
    }
}
