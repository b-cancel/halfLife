//add lower title If there is a lower bound
//add upper title If there is an upper bound

/*
new charts.ChartTitle('Top title text',
            subTitle: 'Top sub-title text',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
        new charts.ChartTitle('Bottom title text',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Start title',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('End title',
            behaviorPosition: charts.BehaviorPosition.end,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
*/

//domain axis

/*
domainAxis: new charts.OrdinalAxisSpec(
          viewport: new charts.OrdinalViewport('2018', 4)),
*/

//sliders for upper and lower bounds
//let them slide freely
//simply make the one on top the upper bound
//and the one at the bottom the lower bound

/*
https://google.github.io/charts/flutter/example/behaviors/slider
*/

//intial hint or something

/*
// Add this behavior to show initial hint animation that will pan to the
        // final desired viewport.
        // The duration of the animation can be adjusted by pass in
        // [hintDuration]. By default this is 3000ms.
        new charts.InitialHintBehavior(maxHintTranslate: 4.0),
*/