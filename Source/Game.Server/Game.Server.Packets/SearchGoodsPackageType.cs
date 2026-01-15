namespace Game.Server.Packets
{
	public enum SearchGoodsPackageType
	{
		TRYENTER = 0,
		RollDice = 1,
		UpgradeStartLevel = 2,
		TakeCard = 3,
		Refresh = 4,
		QuitTakeCard = 5,
		PlayerEnter = 16,
		PlayerRollDice = 17,
		PlayerUpgradeStartLevel = 18,
		BeforeStep = 19,
		BackStep = 20,
		ReachTheEnd = 21,
		BackToStart = 22,
		GetGoods = 23,
		FlopCard = 24,
		PlayNowPosition = 25,
		TakeCardResponse = 32,
		RemoveEvent = 33,
		OneStep = 34
	}
}
