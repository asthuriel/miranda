class Flixpot.Managers.Recommendations extends SimPL.Manager
  endpoint: '/api/recommendations'
  onAdd: null

  controlData:
    objname: 'recommendation'

  batchAddItem: (inx, success, spotId, mediaItemId, senderId, recipientArray, callback) ->
    if inx >= recipientArray.length
      callback(success)
    else
      newRecommendationItem =
        recipient_id: recipientArray[inx]
        sender_id: senderId
        spot_id: spotId
        media_item_id: mediaItemId
      @addItem newRecommendationItem, (intSuccess) =>
        if intSuccess
          @batchAddItem(inx+1, intSuccess, spotId, mediaItemId, senderId, recipientArray, callback)
        else
          callback(intSuccess)

  batchAdd: (spotId, mediaItemId, senderId, recipientArray, callback) ->
    @batchAddItem(0, false, spotId, mediaItemId, senderId, recipientArray, callback)







