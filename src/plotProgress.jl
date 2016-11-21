import Plots: plot, gr
export plotSummary
function plotSignal(y)
    gr()
    epIdx=1:length(y[1])
    plot([epIdx, y[3], epIdx, [0,1]],[y[1],y[4], y[2],[0,1]], line=[:line :scatter :line :line], color=["blue" "black" "orange" "red"],markeralpha=0.05, layout=2,fmt=:png)
end

function plotSummary(model)
      gr()
      yNorm=model.yNorm
      pred=predict(model,model.weights,model.xNorm)
	  #Plot whole training trace
      display(plot([model.lossesTrain, model.lossesVali],color=["blue" "orange"],fmt=:png, label=["Training" "Validation"]))
	  #Plot only last 80% and no peaks
	  nEpoch=length(model.lossesTrain)
	  start=trunc(Int,nEpoch*0.2)
	  idx=start:nEpoch
	  upperQuantTrainLoss=quantile(model.lossesTrain[idx], 0.95)
	  upperQuantValiLoss=quantile(model.lossesVali[idx], 0.95)

	  miniTrainLoss=minimum(model.lossesTrain[idx])
	  miniValiLoss=minimum(model.lossesVali[idx])
      display(plot([idx,idx],[model.lossesTrain[idx], model.lossesVali[idx]],color=["blue" "orange"], fmt=:png, ylim=[(miniTrainLoss, upperQuantTrainLoss) (miniValiLoss,upperQuantValiLoss)], label=["Training" "Validation"], layout=(2,1)))

      #Scatterplot MOD vs OBS
	  min=minimum(vec(yNorm))
	  max=maximum(vec(yNorm))
	  
      display(plot([vec(pred), [min, max]], [vec(yNorm), [min, max]], line=[:scatter :line], color=[:black :red], markeralpha=0.05, label=["OBS vs. MOD", "1:1-line"], fmt=:png))
      println("Correlation: ", cor(vec(pred), vec(yNorm)))
end
