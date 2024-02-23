# fits one rating model so that the image includes a precompiled model

from ratingcurve.ratings import PowerLawRating
from ratingcurve import data

# load tutorial data
df = data.load('green channel')

# initialize the model
powerrating = PowerLawRating(segments=2)
                                   
# fit the model
trace = powerrating.fit(q=df['q'],
                        h=df['stage'], 
                        q_sigma=df['q_sigma'])
