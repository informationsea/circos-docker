FROM debian:10-slim AS download-circos
ARG CIRCOS_VERSION=0.69-9
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -OLf http://circos.ca/distribution/circos-${CIRCOS_VERSION}.tgz
RUN tar xzf circos-${CIRCOS_VERSION}.tgz

FROM debian:10-slim
RUN apt-get update && apt-get install -y perl cpanminus build-essential \
    libextutils-pkgconfig-perl libextutils-makemaker-cpanfile-perl libgd-dev && \
    rm -rf /var/lib/apt/lists/*
RUN cpanm Clone Config::General Font::TTF::Font GD GD::Polyline Math::Bezier Math::Round Math::VecStat \
    Params::Validate Readonly Regexp::Common SVG Set::IntSpan Statistics::Basic Text::Format
RUN mkdir -p /opt
ARG CIRCOS_VERSION=0.69-9
COPY --from=download-circos /circos-${CIRCOS_VERSION} /opt/circos-${CIRCOS_VERSION}
ENV PATH=/opt/circos-${CIRCOS_VERSION}/bin:${PATH}
RUN circos -modules