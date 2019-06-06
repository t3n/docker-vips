FROM quay.io/t3n/debian-base:stretch as builder

ENV LIBVIPS_VERSION 8.7.4

RUN clean-install automake build-essential ca-certificates curl gobject-introspection \
    gtk-doc-tools libglib2.0-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libtool \
    libtiff5-dev libgif-dev libexif-dev libxml2-dev libpoppler-glib-dev pngquant\
    swig libmagickwand-dev libpango1.0-dev libmatio-dev libopenslide-dev \
    libcfitsio-dev libgsf-1-dev fftw3-dev liborc-0.4-dev librsvg2-dev && \
    # Build libvips
    curl -fsSL https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz -o /tmp/vips.tar.gz && \
    tar xzf /tmp/vips.tar.gz -C /tmp && \
    cd /tmp/vips-${LIBVIPS_VERSION} && \
    ./autogen.sh && \
    ./configure \
    --prefix=/usr/local \
    --without-python \
    --without-gsf \
    --enable-debug=no \
    --disable-dependency-tracking \
    --disable-static \
    --disable-introspection \
    --enable-silent-rules && \
    make && \
    make install && \
    ldconfig && \
    # Clean up
    clean-uninstall automake build-essential


FROM quay.io/t3n/debian-base:stretch

RUN clean-install libglib2.0-0 libjpeg62-turbo libpng16-16 libopenexr22 \
    libwebp6 libtiff5 libgif7 libexif12 libxml2 libpoppler-glib8 \
    libmagickwand-6.q16-3 libpango1.0-0 libmatio4 libopenslide0 \
    libgsf-1-114 fftw3 liborc-0.4 librsvg2-2 libcfitsio5 libwebpmux2 \
    ca-certificates

COPY --from=builder /usr/local/lib /usr/local/lib
RUN ldconfig
